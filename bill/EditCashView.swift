//
//  EditCashView.swift
//  
//
//  Created by t&a on 2022/09/04.
//

import SwiftUI

struct EditCashView: View {
    // MARK: - Environment
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.dismiss) var dismiss
    
    let fileController = FileController()
    @EnvironmentObject  var allCashData:AllCashData
    
    // MARK: - View
    @State var isAlertDelete:Bool = false
    @State var isAlertUpdate:Bool = false
    
    // MARK: -　プロパティ
    @Binding var selectedMember:Int    // Pickerで選択されたIndex
    @State var cash:Int? = nil         // Bindingしている金額
    @State var memo:String = ""        // 入力されたMemo情報
    @State var cashString:String  = "" // 入力された金額情報 String型
    
    
    @State var memberArray:[String] = [""]
    @AppStorage("eventName") var eventName:String = "" // イベント名
    @AppStorage("member") var member:String = ""  // 配列が格納できないため文字列で保存
    
    var item:CashData

    
    var body: some View {
        VStack{
            
            EventNameView(eventName: eventName)
            MemberView(selectedMember: $selectedMember,memberArray: memberArray)
            
            // 金額
            InputView(selectedMember: $selectedMember, cash: $cash, memo: $memo
)
            
            // MARK: -　更新＆削除処理
            HStack{
                ButtonView(parentFunction: {
                    isAlertDelete = true
                }, text: "削除",disable: Binding.constant(false),size: 100)
                .alert(isPresented: $isAlertDelete){
                    Alert(title:Text("Question..?"),
                          message: Text("料金情報を削除しますか？"),
                          primaryButton: .destructive(Text("削除する"),
                                                      action: {
                        withAnimation(.linear(duration: 0.3)){
                            allCashData.removeCash(item)   // 選択されたitemを削除
                            fileController.updateJson(allCashData.allData) // JSONファイルを更新
                            allCashData.setAllData() // JSONファイルをプロパティにセット
                            allCashData.sumBill()
                            dismiss()
                        }
                    }), secondaryButton: .cancel(Text("キャンセル")))
                }
                
                
                
                
                ButtonView(parentFunction: {
                    allCashData.updateLocation(
                        CashData(id: item.id,
                                 cash: cash!,
                                 memo: memo,
                                 member: memberArray[selectedMember],
                                 time: item.time),
                        item.id)
                    fileController.updateJson(allCashData.allData) // JSONファイルを更新
                    allCashData.setAllData() // JSONファイルをプロパティにセット
                    allCashData.sumBill()
                    isAlertUpdate = true
                }, text: "更新",disable: Binding.constant(false),size: 100)
                .alert(isPresented: $isAlertUpdate){
                    Alert(title:Text("Confirmation"),
                          message: Text("料金情報を更新しました。"),
                          dismissButton: .cancel(Text("OK"),action: {
                            dismiss()
                    }))
                }
                
            }
            // MARK: -　更新＆削除処理
            
            Spacer()
            
            AdMobBannerView().frame( height:30)
                .padding(.bottom)
            
            
        }
        .onAppear{
            cash = item.cash
            memo = item.memo
            cashString = String(cash!)
            if member != "" {
                memberArray = member.components(separatedBy: ",")
                selectedMember = memberArray.firstIndex(of: item.member)!
            }
        }
    }
}

struct EditCashView_Previews: PreviewProvider {
    static var previews: some View {
        EditCashView(selectedMember: Binding.constant(1),item:CashData(cash: 20))
    }
}
