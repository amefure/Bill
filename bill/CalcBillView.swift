//
//  CalcBillView.swift
//  bill
//
//  Created by t&a on 2022/07/10.
//

import SwiftUI

struct CalcBillView: View {
    
    // View----------------------------------------------------------
    var grids = Array(repeating: GridItem(.fixed(80), spacing: 20), count: 3)
    // プロパティ------------------------------------------------------
    @State var people:Int = 1 // 割り勘にする人数を格納
    @Binding var bill:Int     // 請求金額 親とバインディング
    @State var customStr:String = "" // 割り勘にする人数を格納
    
    // 関数-----------------------------------------------------------
    func setPeople(_ str:String){
        let num = changeNum(str)
        if num > 0 {
            people = num
        }
        customStr = ""
    }
    
    // 文字列を数値に変換
    func changeNum(_ text:String) -> Int{
        guard let num = Int(text) else{
            return 0
        }
        return num
    }
    
    // 関数-----------------------------------------------------------
    
    var body: some View {

        
        VStack {
            HStack {
                Text("合計：")
                Text("¥\(bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
            }.padding()
            HStack {
                Text("\(people)人で割ると.....").foregroundColor(.gray)
            }.padding()
            HStack {
                Text("1人：")
            
                Text("¥\(bill / people)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
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
            
            VStack {
                Text("割り勘する人数(カスタム)").foregroundColor(.gray)
            TextField("人", text: $customStr)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .frame(width: 200)
                // .focused($isActive) は親側に指定する
            }
            Button(action: {
                setPeople(customStr)
            }, label: {
                Text("確定")
            })
            
            
        }.frame( maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
  
    }
}

struct CalcBillView_Previews: PreviewProvider {
    static var previews: some View {
        CalcBillView(bill: Binding.constant(1000))
            .previewInterfaceOrientation(.portrait)
    }
}
