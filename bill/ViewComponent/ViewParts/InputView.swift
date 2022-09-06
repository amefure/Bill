//
//  InputView.swift
//  bill
//
//  Created by t&a on 2022/09/06.
//

import SwiftUI

struct InputView: View {
    // MARK: - Environment
    // ダークモード対応
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    // MARK: - FocusState
    @FocusState var isActive:Bool   // キーボードフォーカス
    
    // MARK: - View
    @Binding var selectedMember:Int    // Pickerで選択されたIndex
    @State var isCorrect:Bool = false       // 入力された金額が数値かどうか
    
    // MARK: -　プロパティ
    @Binding var cash:Int?            // Bindingしている金額
    @Binding var memo:String          // 入力されたMemo情報
    @State var cashString:String  = "" // 入力された金額情報 String型
    
    
    @State var memberArray:[String] = [""]
    @AppStorage("member") var member:String = ""  // 配列が格納できないため文字列で保存
    
    // 文字列を数値に変換
    func changeNum(_ text:String) -> Int?{
        if text != ""  {
            guard let num = Int(text) else{
                isCorrect = false
                return nil
            }
            isCorrect = true
            return num
        }
        return nil
    }
    
    var body: some View {
        Group{
            // 金額
            TextField("¥",text: $cashString)
                .keyboardType(.numberPad)
                .foregroundColor(isCorrect ? (colorScheme == .dark ? Color.white : Color.black) : .red)
                .multilineTextAlignment(.trailing)
                .frame(width: 200)
                .focused($isActive)
                .onChange(of: cashString) { newValue in
                    if changeNum(newValue) != nil {
                        cash = changeNum(newValue)
                    }
                }
                .toolbar{
                    ToolbarItemGroup(placement: .keyboard, content: {
                        Spacer()
                        Button("閉じる"){
                            isActive = false
                        }
                    })
                }
            // メモ
            TextField("使用した名称",text: $memo)
                .multilineTextAlignment(.trailing)
                .frame(width: 200)
                .focused($isActive)
            
            
            PickerMemberView(selectedMember: $selectedMember, memberArray: memberArray)
        }
        .onChange(of: cash) { newValue in
            if cash != nil {
                // Edit時に受け取ったcashをTextFieldと連動させる
                cashString = String(newValue!)
            }else{
                // Entry時に入力値をリセット
                cashString = ""
            }
        }
        .onAppear(){
            if member != "" {
                memberArray = member.components(separatedBy: ",")
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(selectedMember: Binding.constant(1), cash: Binding.constant(1), memo: Binding.constant(""))
    }
}
