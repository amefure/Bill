//
//  EntryEventView.swift
//  bill
//
//  Created by t&a on 2022/09/01.
//

import SwiftUI

struct EntryEventButtonView: View {
    
    // MARK: - Environment > インスタンス
    @EnvironmentObject  var allCashData:AllCashData
    @EnvironmentObject var allEventData:AllEventData
    
    let fileController = FileController()
    
    
    // MARK: - View
    @State var isAlert:Bool = false             // 保存ポップアップアラート
    @State var isLimitAlert:Bool = false        // 保存制限ポップアップアラート
    @State var isSuccessEventAlert:Bool = false // 保存成功ポップアップアラート
    
    
    @Binding var eventName:String      // イベント名
    @Binding var memberArray:[String]  // @AppStorage("member")の配列形式
    
    // MARK: - メソッド
    var parentStorageResetFunction: () -> Void
    
    var body: some View {
        ButtonView(parentFunction: {isAlert = true}, text: "イベント終了",disable: Binding.constant(false),size: 100)
            .alert("お疲れ様です。\nイベントを保存しますか？",isPresented: $isAlert) {
                Button(action: {
                    
                    if fileController.loadLimitTxt() <= allEventData.allData.count{
                        isLimitAlert = true
                    }else{
                        let eventData = EventData(name: eventName, member: memberArray, cashData: allCashData.allData)
                        // 構造体を保存
                        fileController.saveEventJson(eventData)
                        isSuccessEventAlert = true
                    }
                    
                }, label: {
                    Text("保存する")
                })
                Button(role: .destructive, action: {
                    parentStorageResetFunction()
                }, label: {
                    Text("保存しない")
                })
                Button(role:.cancel,action: {
                    isAlert = false
                }, label: {
                    Text("キャンセル")
                })
            }
            .alert(isPresented: $isLimitAlert){
                Alert(title:Text("上限に達しました"),
                      message: Text("広告を視聴すると\nイベントの枠を増やすことができます。"),
                      dismissButton: .default(Text("OK")))
            }
            .alert("「イベント:\(eventName)」を\n保存しました",isPresented:$isSuccessEventAlert) {
                Button(action: {
                    parentStorageResetFunction()
                    
                }, label: {
                    Text("OK")
                })
            }
    }
}

struct EntryEventView_Previews: PreviewProvider {
    static var previews: some View {
        EntryEventButtonView(eventName: Binding.constant(""), memberArray: Binding.constant([]),parentStorageResetFunction: {})
    }
}
