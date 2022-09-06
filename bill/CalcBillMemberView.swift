//
//  CalcBillMemberView.swift
//  bill
//
//  Created by t&a on 2022/09/04.
//

import SwiftUI

struct CalcBillMemberView: View {
    // MARK: -　プロパティ
    @EnvironmentObject var allCashData:AllCashData
    @Binding var memberArray:[String] // @AppStorage("member")の配列形式
    
    let columns =  Array(repeating: GridItem(.fixed(110),alignment: .trailing), count: 3)
    
    // MARK: -　関数
    func sumMemberBill(_ memberIndex:Int) -> Int{
        var result = 0
        for cashData in allCashData.allData {
            if cashData.member == memberArray[memberIndex] {
                result += cashData.cash
            }
        }
        return result
    }
    
    func differenceBill(_ memberIndex:Int) -> Int{
        let sumAmount = sumMemberBill(memberIndex)
        let splitAmount = allCashData.bill / memberArray.count
        let result = sumAmount - splitAmount
        return result
    }
    
    var body: some View {
        VStack{
            // MARK: -　Header
            VStack{
                Text("明細").font(.system(size:30)).fontWeight(.bold) .foregroundColor(.gray).padding(.bottom,5)
                Text("1人：¥\(allCashData.bill / memberArray.count)").font(.custom("AppleSDGothicNeo-SemiBold", size: 25)).foregroundColor(.gray).lineLimit(1)
                Rectangle()
                    .foregroundColor(Color("ThemaColor"))
                    .frame(height: 2)
                
            }
            // MARK: -　明細
            ScrollView{
                VStack{
                    ForEach (memberArray.indices ,id: \.self) { i in
                        LazyVGrid(columns: columns) {
                            Text(memberArray[i]).padding(5).foregroundColor(.white)
                                .background(Color("ThemaColor"))
                                .cornerRadius(5)
                            Text("¥\(sumMemberBill(i))")
                            
                            if differenceBill(i) > 0{
                                Text(" + ¥\(differenceBill(i))")
                                    .foregroundColor(.blue)
                            }else{
                                Text(" - ¥\(abs(differenceBill(i)))")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }.padding()
            
            // MARK: -　広告
            AdMobBannerView().frame( height:30)
                .padding(.bottom)
        }
    }
}

struct CalcBillMemberView_Previews: PreviewProvider {
    static var previews: some View {
        CalcBillMemberView(memberArray: Binding.constant([]))
    }
}
