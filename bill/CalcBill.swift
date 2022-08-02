//
//  CalcBill.swift
//  bill
//
//  Created by t&a on 2022/07/05.
//

import SwiftUI

struct CalcBill: View {
        var grids = Array(repeating: GridItem(.fixed(80), spacing: 20), count: 3)
        @State var people:Int = 1 // 割り勘にする人数を格納
        @Binding var bill:Int     // 請求金額 親とバインディング
        
        var body: some View {

            
            VStack {
                HStack {
                    Text("合計：")
                    Text("¥\(bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray)
                }.padding()
                HStack {
                    Text("\(people)人で割ると.....").foregroundColor(.gray)
                }.padding()
                HStack {
                    Text("1人：")
                
                    Text("¥\(bill / people)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray)
                }.padding()
                LazyVGrid(columns: grids){
                    Group {
                        
                        Button(action: {
                            people = 2
                        }, label: {
                            Image(systemName: "figure.stand").offset(x: 5)
                            Image(systemName: "figure.stand").offset(x: -5)
                        }).padding().frame(width: 80, height: 80)
                        
                        Button(action: {
                            people = 3
                        }, label: {
                            Image(systemName: "figure.stand").offset(x: 10)
                            Image(systemName: "figure.stand")
                            Image(systemName: "figure.stand").offset(x: -10)
                        }).padding().frame(width: 80, height: 80)
                        
                        Button(action: {
                            people = 4
                        }, label: {
                            Image(systemName: "figure.stand").offset(x: 15)
                            Image(systemName: "figure.stand").offset(x: 5)
                            Image(systemName: "figure.stand").offset(x: -5)
                            Image(systemName: "figure.stand").offset(x: -15)
                        }).padding().frame(width: 80, height: 80)
                        
                    }.background(Color(red: 0.2, green: 0.5 ,blue: 0.2))
                    .cornerRadius(8)
                    .foregroundColor(Color.white)
                    
                }.padding()
                .border(Color.green,width: 2)
                
                
            }.frame( maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                .ignoresSafeArea()
                
            
        }
}

struct CalcBill_Previews: PreviewProvider {
    static var previews: some View {
        CalcBill(bill: Binding.constant(1000))
            .previewInterfaceOrientation(.portrait)
    }
}
