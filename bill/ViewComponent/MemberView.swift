//
//  MemberView.swift
//  bill
//
//  Created by t&a on 2022/08/30.
//

import SwiftUI

struct MemberView: View {
    @Binding var selectedMember:Int
    var memberArray:[String]
    // メンバーが偶数なら2列にonApperで変更
    @State var columns = Array(repeating: GridItem(.fixed(120)), count: 3) // 初期値は3列
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns) {
                ForEach (memberArray.indices ,id: \.self) { i in
                    Button(action: {
                        selectedMember = i
                    }, label: {
                        HStack{
                            Image(systemName: "person.fill")
                            Text(memberArray[i])
                        }.padding(5)
                            .foregroundColor(.white)
                            .background(Color("ThemaColor"))
                            .cornerRadius(5)
                    }).disabled((selectedMember == -1)) // イベント履歴からの呼び出しでは使用不可
                }
            }
        }.frame(height: (UIDevice.current.userInterfaceIdiom == .pad ? 300 : 70))
            .onAppear(){
                if memberArray.count % 2 == 0{
                    columns = Array(repeating: GridItem(.fixed(120)), count: 2)
                }
            }
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView(selectedMember: Binding.constant(1),memberArray: [])
    }
}
