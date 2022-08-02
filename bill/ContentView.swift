//
//  ContentView.swift
//  bill
//
//  Created by t&a on 2022/07/04.
//

import SwiftUI

struct ContentView: View {
    
    // View----------------------------------------------------------
    @State var selectedTag = 1      //  タブビュー
    @State var isAlert:Bool = false // アラート
    @State var isLinkEnable:Bool = false // アラート
    @FocusState var isActive:Bool   // キーボードフォーカス
    // ダークモード対応
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    
    // インスタンス----------------------------------------------------
    // ファイルコントローラークラスをインスタンス化
    let fileController = FileController()
    // 全キャッシュ情報をデータとして持つクラスをインスタンス化
    @ObservedObject var allCashData = AllCashData()
    
    // プロパティ------------------------------------------------------
    
    @State var cash:String = ""  // 入力された金額情報
    @State var memo:String = ""  // 入力されたMemo情報
    @State var isCorrect:Bool = true // 入力された金額が数値かどうか
    
    // 関数-----------------------------------------------------------
    // 文字列を数値に変換
    func changeNum(_ text:String) -> Int{
        guard let num = Int(text) else{
            isCorrect = false
            return 0
        }
        isCorrect = true
        return num
    }
    
    
    // 入力フォームをリセット
    func deleteInput(){
        cash = "" // 入力値をクリア
        memo = "" // 入力値をクリア
    }
    
    // 全情報をリフレッシュ 子Viewに渡す
    func refreshData(){
        allCashData.setAllData() // AllDataインスタンスのプロパティをリセット
        allCashData.sumBill()  // 請求金額をリセット
    }
    
    // -------------------------------------------------------------
    
    
    
    
    var body: some View {
        
        TabView(selection: $selectedTag){
            NavigationView{
            // cash蓄積View
            VStack {
                
                
                //  合計請求金額---------------------------------------
                Text("¥\(allCashData.bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
                //  合計請求金額---------------------------------------
                
                //  入力フォーム---------------------------------------
                Group {
                    // 金額
                    TextField("¥",text: $cash)
                        .keyboardType(.numberPad)
                        .foregroundColor(isCorrect ? (colorScheme == .dark ? Color.white : Color.black) : .red)

                    // メモ
                    TextField("memo",text: $memo)
                                                
                }.textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isActive)
                .multilineTextAlignment(.trailing)
                .frame(width: 200)
                //  入力フォーム---------------------------------------
                
                //  ボタン---------------------------------------
                HStack (spacing: 30){
                    
                        //  リセットボタン
                        Button(action: {
                            isAlert = true // アラートを表示
                        }, label: {
                            Text("リセット").frame(width: 100)
                        }).padding()
                        .background(Color(red: 0.2, green: 0.5 ,blue: 0.2))
                        .cornerRadius(8)
                        .alert(isPresented: $isAlert) {
                            Alert(title: Text("確認"), message: Text("データをリセットしてもよろしいですか？"),
                                primaryButton: .destructive(Text("削除する"),action: {
                                fileController.clearFile() // ファイルをクリア
                                refreshData() // データのリフレッシュ
                                deleteInput() // 入力フォームのリセット
                            }), secondaryButton: .cancel(Text("キャンセル")))
                        }
                        //  リセットボタン
                    
                        //  登録ボタン
                        Button(action: {
                            // TextField文字列を数値に変換
                            let num = changeNum(cash)

                            // 数値じゃない場合and0じゃない場合
                            if num != 0 {
                                // 構造体に倣って構築
                                let cashData = CashData(cash:num,memo:memo)
                                // 構造体を保存
                                fileController.saveJson(cashData)
                                refreshData()  // データのリフレッシュ
                                deleteInput()  // 入力フォームのリセット
                            }

                        }, label: {
                            Text("登録").frame(width: 100)
                        }).padding()
                        .background(Color(red: 0.2, green: 0.5 ,blue: 0.2))
                        .cornerRadius(8)
                        //  登録ボタン
                        
                }.padding()
                    .foregroundColor(.white)
                    
                    
                //  ボタン---------------------------------------
                
                // リスト表示ボタンリンク----------------------------------
                
                Button(action: {
                    if allCashData.allData.isEmpty {
                        isLinkEnable = false
                    }else{
                        isLinkEnable = true
                    }
                    
                }, label: {
                    Spacer()
                    Image(systemName: "list.bullet").padding()
                    .font(.system(size: 20))
                    
                })
                
                NavigationLink(destination: ListCashView(parentRefreshFunction: self.refreshData),isActive: $isLinkEnable, label: {
                    EmptyView()
                })
                
      
                // リスト表示ボタンリンク----------------------------------
                
                
                // 3行くらいデモ表示したい
                ScrollView{
                    
                    LazyVStack {
                        ForEach (allCashData.allData.reversed()) { item in
                            RowCashView(item: item)
                        }.frame(height: 50)
                            .padding([.leading,.trailing])
                    }
                }.frame(height: 150)
                
                
            } // Navigation
                
            }.tabItem{

                    Image(systemName: "pencil.circle")
                    Text("Add")
                
            }.tag(1)
                .frame( maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
                
            
            // 割り勘計算View
            CalcBillView(bill: $allCashData.bill).tabItem{
                Image(systemName: "yensign.circle")
                Text("Calc")
            }.tag(2)
                .focused($isActive) // 子ViewのTextFieldのフォーカスはここに指定
        }
        .ignoresSafeArea()
        .accentColor(.orange)
        .toolbar{
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button("閉じる"){
                    isActive = false
                }
            })
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
