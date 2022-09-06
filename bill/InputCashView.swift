//
//  InputCashView.swift
//  bill
//
//  Created by t&a on 2022/09/04.
//

import SwiftUI

struct InputCashView: View {

    // MARK: - Environment > インスタンス
    @EnvironmentObject  var allCashData:AllCashData
    @EnvironmentObject var allEventData:AllEventData
    
    let fileController = FileController()
    
    // MARK: -　プロパティ
    @Binding var selectedMember:Int    // Pickerで選択されたIndex
    @Binding var cash:Int?             // Bindingしている金額
    @Binding var memo:String           // 入力されたMemo情報
    
    @Binding var eventName:String  // イベント名
    @Binding var memberArray:[String]  // @AppStorage("member")の配列形式

    // MARK: - メソッド
    
    var parentStorageResetFunction: () -> Void
    
    // 入力フォームをリセット 登録処理後とイベント削除時
    func deleteInput(){
        cash = nil  // 入力値をクリア
        memo = "" // 入力値をクリア
    }
    
    // Cashデータのリフレッシュ
    func refreshCashData(){
        allCashData.setAllData()  // Cashインスタンスのプロパティをリセット
        allCashData.sumBill()  // 請求金額をリセット
    }
    
    // イベントを初期化 EntryEventViewから呼び出し用
    func resetEvent(){
        fileController.clearFile() // ファイルをクリア
        refreshCashData() // Cashデータのリフレッシュ
        allEventData.setAllData() // Eventインスタンスのプロパティをリセット
        deleteInput()  // 入力フォームのリセット
        parentStorageResetFunction() // ストレージリセット
    }
    
    var body: some View {
        VStack{
            // MARK: -　入力フォーム
            InputView(selectedMember: $selectedMember, cash: $cash, memo: $memo)
            // MARK: -　入力フォーム
            
            // MARK: -　ボタン
            HStack{
                // MARK: -　登録ボタン
                ButtonView(parentFunction: {
                    if cash != nil  {  // 数値じゃない場合は格納不可
                        // 構造体に倣って構築
                        let cashData = CashData(cash:cash!,memo:memo,member: memberArray[selectedMember])
                        // 構造体を保存
                        fileController.saveJson(cashData)
                        refreshCashData()  // データのリフレッシュ
                        deleteInput()  // 入力フォームのリセット
                    }
                }, text: "登録",disable: Binding.constant(false),size: 100)
                
                // MARK: -　イベント終了ボタン
                EntryEventButtonView(eventName: $eventName, memberArray: $memberArray,parentStorageResetFunction: resetEvent).environmentObject(allCashData).environmentObject(allEventData)
            } // HSatck
            // MARK: -　ボタン
        }
        

    }
}

struct InputCashView_Previews: PreviewProvider {
    static var previews: some View {
        InputCashView(selectedMember: Binding.constant(1) ,cash: Binding.constant(9), memo: Binding.constant(""),eventName: Binding.constant(""), memberArray: Binding.constant([]),parentStorageResetFunction:{})
    }
}
