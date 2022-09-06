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
    var eventItem: EventData?
    
    @State var selectedMember:Int = -1  // Pickerで選択されたIndex
    @State var isCorrect:Bool  = true   // 入力された金額が数値かどうか
    
    var body: some View {
        VStack {
            
            if eventItem != nil {
                Text("\(eventItem!.time)").font(.custom("AppleSDGothicNeo-SemiBold", size: 15)).foregroundColor(.gray).lineLimit(1).offset(x: -100, y: 10)
                VStack{
                    EventNameView(eventName: eventItem!.name)
                    MemberView(selectedMember: Binding.constant(-1),
                               memberArray: eventItem!.member)
                }.offset(x: 0, y: -40)
            }
            
            
            List (displayCashData.reversed()) { item in
                if eventItem == nil {
                    // 編集Inputの呼び出し
                    NavigationLink(destination: {
                        EditCashView(
                            selectedMember: $selectedMember,      // 不要 入力された金額が数値かどうか
                            item: item
                        )
                    }, label: {
                        RowCashView(item: item)
                    })
                }else{
                    
                    RowCashView(item: item)
                }
                
            }.listStyle(GroupedListStyle()) // Listのスタイルを横に広げる
                .offset(x: 0, y: (eventItem == nil ? 0 : -40))
            
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
