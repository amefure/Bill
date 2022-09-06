//
//  CalcBillView.swift
//  bill
//
//  Created by t&a on 2022/07/10.
//

import SwiftUI

struct CalcBillView: View {
    // MARK: -　Environment
    @EnvironmentObject var allCashData:AllCashData
    @EnvironmentObject var allEventData:AllEventData
    
    // MARK: -　プロパティ
    @State var people:Int = 1         // 割り勘にする人数を格納 初期値1 イベント有→メンバーの数
    @State var customStr:String = ""  // カスタム人数を格納
    @State var rouletteResult:String = "" // 割り勘にするメンバー名を格納
    @State var isLink:Bool = false
    @Binding var memberArray:[String] // @AppStorage("member")の配列形式
    
    // MARK: - FocusState
    @FocusState var isActive:Bool   // キーボードフォーカス
    // MARK: -　メソッド
    func setPeople(_ str:String){
        let num = changeNum(str)
        if num > 0 {
            people = num
        }
    }
    
    func changeNum(_ text:String) -> Int{
        guard let num = Int(text) else{
            return 0
        }
        return num
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("合計：")
                Text("¥\(allCashData.bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
            }.padding()
            
            HStack {
                Text("\(people)人で割ると.....").foregroundColor(.gray)
    
            }.padding()
            
            HStack {
                Text("1人：")
                
                Text("¥\(allCashData.bill / people)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
                
                NavigationLink(destination: {CalcBillMemberView(memberArray: $memberArray)}, label: {
                    
                    Image(systemName: "person.text.rectangle")
                })
            }.padding()
            
            NavigationLink(isActive: $isLink,destination: {RouletteView(rouletteResult: $rouletteResult, memberArray: $memberArray)}, label: {
                ButtonView(parentFunction: {isLink = true}, text: "ルーレットスタート", disable: Binding.constant(false), size: 200)
            })
            
            VStack {
                Text("割り勘する人数(カスタム)").foregroundColor(.gray)
                TextField("人", text: $customStr)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.trailing)
                    .frame(width: 200)
                    .focused($isActive)

            }.toolbar{
                ToolbarItemGroup(placement: .keyboard, content: {
                    Spacer()
                    Button("閉じる"){
                        isActive = false
                    }
                })
            }
            
            Button(action: {
                setPeople(customStr)
            }, label: {
                Text("確定")
            })
            
            
            
        }.frame( maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom)
            .ignoresSafeArea()
            .accentColor(.orange)
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
