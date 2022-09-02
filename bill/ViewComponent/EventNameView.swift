//
//  EventNameView.swift
//  bill
//
//  Created by t&a on 2022/09/01.
//

import SwiftUI

struct EventNameView: View {
    var eventName: String
    var body: some View {
        VStack{
            Text(eventName).font(.system(size:30)).fontWeight(.bold) .foregroundColor(.gray)
            Rectangle()
                .foregroundColor(Color("ThemaColor"))
                .frame(height: 2)
        }.padding(.bottom,10)
    }
}

struct EventNameView_Previews: PreviewProvider {
    static var previews: some View {
        EventNameView(eventName:"イベント名")
    }
}
