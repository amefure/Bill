//
//  CalcBillView.swift
//  bill
//
//  Created by t&a on 2022/07/10.
//

import SwiftUI

struct CalcBillView: View {
    
    // プロパティ------------------------------------------------------
    @State var people:Int = 1  // 割り勘にする人数を格納 初期値1 イベント有→メンバーの数
    @State var rouletteResult:String = "" // 割り勘にするメンバー名を格納
    @FocusState var isActive:Bool   // キーボードフォーカス
    
    @EnvironmentObject var allCashData:AllCashData
    @EnvironmentObject var allEventData:AllEventData
    @Binding var memberArray:[String] // @AppStorage("member")の配列形式
    
    // 関数-----------------------------------------------------------

    func rouletteStart(){
        if !memberArray.contains(where: {$0 == "割り勘"}){
            memberArray.append("割り勘")
          
        }
        var timer = Timer()
        var timer2 = Timer()
        var stop = false
        timer2 = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){ _ in
            rouletteResult = String(memberArray.randomElement()!)
            timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true){ _ in
                stop = true
            }
            if stop {
                
                timer.invalidate() // タイマーストップ
                timer2.invalidate() // タイマーストップ
                memberArray.removeAll(where: {$0 == "割り勘"})
            }
        }
    }
    
    // 関数-----------------------------------------------------------
    
    var body: some View {
        
        
        VStack {
            
            
            HStack {
                Text("合計：")
                Text("¥\(allCashData.bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
            }.padding()
            HStack {
//                if rouletteResult == "割り勘" || rouletteResult == "" {
                    Text("\(people)人で割ると.....").foregroundColor(.gray)
//                }else{
//                    Text("\(rouletteResult)の負担額は...")
//                }
                
            }.padding()
            HStack {
                Text("1人：")
                
                Text("¥\(allCashData.bill / people)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
            }.padding()
            
            ButtonView(parentFunction: {rouletteStart()}, text: "ルーレットスタート", disable: Binding.constant(memberArray == [""]), size: 200)
            
            if rouletteResult != ""{
                if rouletteResult == "割り勘" {
                    Text("仲良く\(rouletteResult)しましょう..")
                }else{
                    Text("\(rouletteResult)の全額奢り！")
                }
                
            }

          
        }.frame( maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .ignoresSafeArea()
            .onAppear(){
                people = memberArray.count
                rouletteResult = ""
            }
            
    }
}

struct CalcBillView_Previews: PreviewProvider {
    static var previews: some View {
        CalcBillView(memberArray: Binding.constant([]))
            .previewInterfaceOrientation(.portrait)
    }
}
