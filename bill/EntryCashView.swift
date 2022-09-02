//
//  EntryCashView.swift
//  bill
//
//  Created by t&a on 2022/09/01.
//

import SwiftUI
import GoogleMobileAds


struct EntryCashView: View {
    
    // MARK: - Environment
    // ダークモード対応
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    // MARK: - Environment > インスタンス
    @EnvironmentObject  var allCashData:AllCashData
    @EnvironmentObject var allEventData:AllEventData
    
    let fileController = FileController()
    
    // MARK: - FocusState
    @FocusState var isActive:Bool   // キーボードフォーカス
    
    // MARK: - View
    @State var selectedMember:Int = 0   // Pickerで選択されたIndex
    @State var isCorrect:Bool = true // 入力された金額が数値かどうか
    
    // MARK: -　プロパティ
    @State var cash:String = ""  // 入力された金額情報
    @State var memo:String = ""  // 入力されたMemo情報
    
    @Binding var eventName:String  // イベント名
    @Binding var memberArray:[String]  // @AppStorage("member")の配列形式
    
    // MARK: - メソッド
    
    var parentStorageResetFunction: () -> Void
    
    // 文字列を数値に変換
    func changeNum(_ text:String) -> Int{
        if text != ""  {
            guard let num = Int(text) else{
                isCorrect = false
                return -1
            }
            isCorrect = true
            return num
        }
        return -1
    }
    
    
    // 入力フォームをリセット 登録処理後とイベント削除時
    func deleteInput(){
        cash = "" // 入力値をクリア
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
        NavigationView{
            VStack {
                Spacer()
                EventNameView(eventName: eventName)
                MemberView(memberArray: memberArray)
                
                Spacer()
                // MARK: -　合計請求金額
                HStack{
                    Spacer()
                    
                    Text("¥\(allCashData.bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
                        .padding(.trailing,20)
                        .padding(.leading,40)
                        .offset(x: 0, y: 10)
                    
                    NavigationLink(destination: {
                        CalcBillView(memberArray:$memberArray).environmentObject(allCashData).environmentObject(allEventData)
                    }, label: {
                        VStack{
                            Text("割り勘")
                            Image(systemName: "yensign.square").font(.system(size: 20))
                        }
                    })
                    
                    Spacer()
                }
                // MARK: -　合計請求金額
                
                // MARK: -　入力フォーム
                VStack{
                    
                    // 金額
                    TextField("¥",text: $cash)
                        .keyboardType(.numberPad)
                        .foregroundColor(isCorrect ? (colorScheme == .dark ? Color.white : Color.black) : .red)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 200)
                        .focused($isActive)
                    
                    // メモ
                    TextField("使用した名称",text: $memo)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 200)
                        .focused($isActive)
                    
                    
                    PickerMemberView(selectedMember: $selectedMember, memberArray: memberArray)
                    
                }.toolbar{
                    ToolbarItemGroup(placement: .keyboard, content: {
                        Spacer()
                        Button("閉じる"){
                            isActive = false
                        }
                    })
                }
                // MARK: -　入力フォーム
                
                // MARK: -　ボタン
                HStack{
                    // MARK: -　登録ボタン
                    ButtonView(parentFunction: {
                        let num = changeNum(cash) // TextField文字列を数値に変換
                        if num != -1 { // 数値じゃない場合
                            // 構造体に倣って構築
                            let cashData = CashData(cash:num,memo:memo,member: memberArray[selectedMember])
                            // 構造体を保存
                            fileController.saveJson(cashData)
                            refreshCashData()  // データのリフレッシュ
                            deleteInput()  // 入力フォームのリセット
                        }
                    }, text: "登録",disable: Binding.constant(false),size: 100)
                    
                    // MARK: -　イベント終了ボタン
                    EntryEventView(eventName: $eventName, memberArray: $memberArray,parentStorageResetFunction: resetEvent).environmentObject(allCashData).environmentObject(allEventData)
                }.padding() // HSatck
                // MARK: -　ボタン
                
                
                
                // MARK: -　リスト 3行デモ表示
                ScrollView{
                    LazyVStack {
                        
                        ForEach (allCashData.allData.reversed()) { item in
                            NavigationLink(destination: {
                                ListCashView(displayCashData: $allCashData.allData,eventItem:EventData(name: "", member: [], cashData: [CashData(cash: 0)]))
                            }, label: {
                                RowCashView(item: item).foregroundColor(.gray)
                            })
                        }.frame(height: 50)
                            .padding([.leading,.trailing])
                    }
                }.frame(height: (UIDevice.current.userInterfaceIdiom == .pad ? 300 : 150))
                // MARK: -　リスト 3行デモ表示
                
                Spacer()
                
                // MARK: -　広告
                AdMobBannerView().frame( height:30)
                    .padding(.bottom)
                
            }.navigationBarHidden(true) // Navigation
                .navigationTitle(eventName)
        }
    }
}

struct EntryCashView_Previews: PreviewProvider {
    static var previews: some View {
        EntryCashView(eventName: Binding.constant(""), memberArray: Binding.constant([]),parentStorageResetFunction:{})
    }
}



