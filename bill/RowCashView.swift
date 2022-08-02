//
//  RowCashView.swift
//  bill
//
//  Created by t&a on 2022/07/13.
//

import SwiftUI

struct RowCashView: View {
    
    // プロパティ------------------------------------------------------
    var item:CashData
    
    var body: some View {
        
        HStack {
            VStack {
                // 位置調整
                Text("memo").font(.caption).foregroundColor(.gray).offset(x: 52, y: -16)
                Text("\(item.time)").font(.caption).foregroundColor(.gray).offset(x: -10, y: 0)
            }
        
            // 縦の線を表示
            Rectangle()
            .foregroundColor(.gray)
            .frame(width: 0.2 ,height: 30)
            
            // メモ
            Text("\(item.memo)").lineLimit(1)
            
            Spacer()
            
            // 金額
            Text("¥\(item.cash)").lineLimit(1)
            
        }.padding([.top,.trailing])
    }
}

struct RowCashView_Previews: PreviewProvider {
    static var previews: some View {
        RowCashView(item: CashData(cash:25000,memo:"宿代")).previewLayout(.sizeThatFits)
    }
}
