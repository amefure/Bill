//
//  InputEventView.swift
//  bill
//
//  Created by t&a on 2022/08/29.
//

import SwiftUI

struct InputEventView: View {
    
    @Binding var isEvent:Bool// 旅行イベントを作成したかどうか
    @Binding var memberArray:[String]  // 入力されたイベント名
    @AppStorage("eventName") var eventName:String = ""
    @AppStorage("member") var member:String = ""
    
    func checkInputDataDisable() -> Bool{
        for member in memberArray {
            if member == ""{
                return true
            }
        }
        if eventName == "" {
            return true
        }else{
            return false
        }
    }
    
    var body: some View {
        VStack{
            Text("イベント名").font(.system(size:20)).padding()
            TextField("例：大阪旅行", text: $eventName).frame(width: 200)
            
            // MARK: -
            Text("メンバー").font(.system(size:20)).padding()
            HStack{
                Button(action: {
                    memberArray.append("")
                }, label: {
                    Image(systemName: "person.fill.badge.plus")
                }).foregroundColor(.orange).padding(5).font(.system(size: 20))
                
                Button(action: {
                    memberArray.removeLast()
                }, label: {
                    Image(systemName: "person.fill.badge.minus")
                }).foregroundColor(memberArray.count == 1  ? .gray : .red).padding(5).font(.system(size: 20)).disabled(memberArray.count == 1)
            }
            ScrollView{
                
                ForEach(memberArray.indices, id: \.self) { i in
                    TextField("メンバー\(i + 1)", text: $memberArray[i]).frame(width: 200).padding(5)
                }
            }.frame(height: 180)
            // MARK: -
            ButtonView(parentFunction: {
                isEvent = true
                var memberString:String = ""
                for member in memberArray {
                     memberString += member + ","
                }
                member = String(memberString.dropLast())
            }, text: "登録",disable: Binding.constant(checkInputDataDisable()),size: 100)
        }
    }
}

struct InputEventView_Previews: PreviewProvider {
    static var previews: some View {
        InputEventView(isEvent: Binding.constant(true),memberArray: Binding.constant([]))
    }
}
