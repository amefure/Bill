//
//  RowEventView.swift
//  bill
//
//  Created by t&a on 2022/08/29.
//

import SwiftUI

struct RowEventView: View {
    var item:EventData
    
    func sumBill(_ data:[CashData]) -> Int{
        var result:Int = 0
        for item in data{
            result += item.cash
        }
        return result
    }
    var body: some View {
        NavigationLink(destination: {ListCashView(displayCashData: Binding.constant(item.cashData), eventItem: item)}, label: {
            HStack {
                VStack {
                    // 位置調整
                    Text("Name").font(.caption).foregroundColor(.gray).offset(x: 52, y: -16)
                    Text("\(item.time)").font(.caption).foregroundColor(.gray).offset(x: -10, y: 0)
                }
            
                // 縦の線を表示
                Rectangle()
                .foregroundColor(.gray)
                .frame(width: 0.2 ,height: 30)
                
                // メモ
                Text("\(item.name)").lineLimit(1)
                
                Spacer()
                
                // 金額
                Text("¥\(sumBill(item.cashData))").lineLimit(1)
                
            }.padding([.top,.trailing])
        })
        
    }
}

struct RowEventView_Previews: PreviewProvider {
    static var previews: some View {
        RowEventView(item: EventData(name: "大阪旅行", member: ["Tom,Michael,Johnny,Joseph"], cashData: [CashData(cash: 2500,memo: "高速代")]))
    }
}
