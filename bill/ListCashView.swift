//
//  ListCashView.swift
//  bill
//
//  Created by t&a on 2022/07/10.
//

import SwiftUI

struct ListCashView: View {
    let fileController = FileController()
    @Binding var displayCashData : [CashData]
    @EnvironmentObject  var allCashData:AllCashData
    
    var eventItem: EventData
    
    var body: some View {
        VStack {

            if !eventItem.member.isEmpty {
                VStack{
                    EventNameView(eventName: eventItem.name)
                    MemberView(memberArray: eventItem.member)
                }.offset(x: 0, y: -40)
            }
            
            List (displayCashData.reversed()) { item in
                if eventItem.member.isEmpty {
                    RowCashView(item: item)
                    .swipeActions(edge: .trailing,allowsFullSwipe: false){
                        Button(role:.destructive,action: {
                            
                            // リストの削除処理にゆっくりのアニメーション
                            withAnimation(.linear(duration: 0.3)){
                                allCashData.removeCash(item)   // 選択されたitemを削除
                                fileController.updateJson(allCashData.allData) // JSONファイルを更新
                                allCashData.setAllData() // JSONファイルをプロパティにセット
                                allCashData.sumBill()
                            }
                            
                        }, label: {
                            Image(systemName: "trash")
                        })
                    }
                }else{
                   
                    RowCashView(item: item)
                }
                 
            }.listStyle(GroupedListStyle()) // Listのスタイルを横に広げる
                .offset(x: 0, y: (eventItem.member.isEmpty ? 0 : -40))
                
            AdMobBannerView().frame( height:30)
                .padding(.bottom)
        }
    }
}

struct ListCashView_Previews: PreviewProvider {
    static var previews: some View {
        ListCashView(displayCashData:Binding.constant([CashData(cash:4753,memo:"高速代"),CashData(cash:2000,memo:"ガソリン代"),CashData(cash:25000,memo:"旅館（梅小路　花伝沙）")]),eventItem: EventData(name: "イベント名", member: ["Yhoo"], cashData: [CashData(cash:4753,memo:"高速代")]))
    }
}
