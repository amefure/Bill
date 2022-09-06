//
//  ButtonView.swift
//  bill
//
//  Created by t&a on 2022/08/29.
//

import SwiftUI

struct ButtonView: View {
    
    var parentFunction: () -> Void
    @State var text:String
    @Binding var disable:Bool  // ボタンを無効にする
    var size:CGFloat
    
    var body: some View {
        Button(action: {
            parentFunction()
        }, label: {
            Text(text).frame(width: size)
        }).padding(10)
            .background(disable ? Color.gray : Color("ThemaColor"))
            .cornerRadius(8)
            .foregroundColor(.white)
            .padding()
            .disabled(disable)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(parentFunction: {},text: "ボタン",disable:Binding.constant(false),size: 200)
    }
}
