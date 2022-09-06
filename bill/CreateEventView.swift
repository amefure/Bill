//
//  CreateEvent.swift
//  bill
//
//  Created by t&a on 2022/08/30.
//

import SwiftUI

struct CreateEventView: View {
    // MARK: - プロパティ
    @Binding var isEvent:Bool// 旅行イベントを作成したかどうか
    @Binding var memberArray:[String]  // 入力されたイベント名
    @State var isEventModal:Bool = false // 旅行イベント入力モーダル
    
    var body: some View {
        VStack{
            Text("Split Bill\nApp for\nTravel").font(.system(size:50)).multilineTextAlignment(.trailing).foregroundColor(.gray)
            ButtonView(parentFunction: {isEventModal = true}, text: "イベントを作成",disable: Binding.constant(false),size: 200)
                .sheet(isPresented:  $isEventModal, content: {
                    InputEventView(isEvent: $isEvent,memberArray: $memberArray)
                })
            Text("旅行で\n使える\n割り勘アプリ").font(.system(size:40)).multilineTextAlignment(.leading).foregroundColor(.gray)
        }
    }
}
struct CreateEvent_Previews: PreviewProvider {
    static var previews: some View {
        CreateEventView(isEvent: Binding.constant(true), memberArray:  Binding.constant([]))
    }
}

