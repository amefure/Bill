//
//  MemberView.swift
//  bill
//
//  Created by t&a on 2022/08/30.
//

import SwiftUI

struct MemberView: View {
    var memberArray:[String]
    let columns = [GridItem(.fixed(90)),GridItem(.fixed(90))]
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach (memberArray.indices ,id: \.self) { i in
                HStack{
                    Image(systemName: "person.fill")
                    Text(memberArray[i])
                }.padding(5)
                    .foregroundColor(.white)
                    .background(Color("ThemaColor"))
                    .cornerRadius(5)
            }
        }
        
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView(memberArray: [])
    }
}
