//
//  EntryCashView.swift
//  bill
//
//  Created by t&a on 2022/09/01.
//

import SwiftUI
import GoogleMobileAds


struct EntryCashView: View {
    
    // MARK: - Environment > インスタンス
    @EnvironmentObject  var allCashData:AllCashData
    @EnvironmentObject var allEventData:AllEventData
    
    let fileController = FileController()
    
    // MARK: - View
    @State var selectedMember:Int = 0   // Pickerで選択されたIndex
    
    // MARK: -　プロパティ
    @State var cash:Int?  = nil  // 入力された金額情報
    @State var memo:String = ""  // 入力されたMemo情報
    
    @Binding var eventName:String  // イベント名
    @Binding var memberArray:[String]  // @AppStorage("member")の配列形式
    
//    // MARK: - メソッド
    var parentStorageResetFunction: () -> Void
    
    var body: some View {
        NavigationView{
            VStack {
                Spacer()
                EventNameView(eventName: eventName).padding(.top,40)
                MemberView(selectedMember: $selectedMember,memberArray: memberArray)
                Spacer()
                // MARK: -　合計請求金額
                HStack{
                    Spacer()
                    
                    Text("¥\(allCashData.bill)").font(.custom("AppleSDGothicNeo-SemiBold", size: 50)).foregroundColor(.gray).lineLimit(1)
                        .padding(.trailing,20)
                        .padding(.leading,40)
                        .offset(x: 0, y: 10)
                    
                    NavigationLink(destination: {
                        CalcBillView(memberArray:$memberArray).environmentObject(allCashData).environmentObject(allEventData)
                    }, label: {
                        VStack{
                            Text("割り勘")
                            Image(systemName: "yensign.square").font(.system(size: 20))
                        }
                    })
                    
                    Spacer()
                }
                // MARK: -　合計請求金額
                
                // MARK: -　入力フォーム
                InputCashView(selectedMember: $selectedMember, cash: $cash, memo: $memo, eventName:$eventName,memberArray:$memberArray,parentStorageResetFunction: parentStorageResetFunction).environmentObject(allCashData).environmentObject(allEventData)
                // MARK: -　入力フォーム
                
                
                // MARK: -　リスト 3行デモ表示
                ScrollView{
                    LazyVStack {
                        ForEach (allCashData.allData.reversed()) { item in
                            NavigationLink(destination: {
                                ListCashView(displayCashData: $allCashData.allData,eventItem:nil)
                            }, label: {
                                VStack{
                                    HStack{
                                        RowCashView(item: item).foregroundColor(.gray)
                                        Image(systemName: "chevron.right")
                                    }
                                
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(height: 1)
                                    .offset(x: 0, y: -10)
                                }
                            })
                        }.frame(height: 50)
                            .padding([.top,.leading,.trailing])
                    }
                }.frame(height: (UIDevice.current.userInterfaceIdiom == .pad ? 300 : 75))
                // MARK: -　リスト 3行デモ表示
                
                // MARK: -　広告
                AdMobBannerView().frame(height:30)
                    .padding(.bottom)
                
                Spacer()
            }.navigationBarHidden(true) // VStack
                .navigationTitle(eventName)
        } // Navigation
    }
}

struct EntryCashView_Previews: PreviewProvider {
    static var previews: some View {
        EntryCashView(eventName: Binding.constant(""), memberArray: Binding.constant([]),parentStorageResetFunction:{})
    }
}



