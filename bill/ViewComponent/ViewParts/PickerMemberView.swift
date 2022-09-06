//
//  PickerMemberView.swift
//  bill
//
//  Created by t&a on 2022/08/30.
//

import SwiftUI

struct PickerMemberView: View {
    
    @Binding var selectedMember:Int
    var memberArray:[String]
    
    var body: some View {
        HStack{
            Text("支払った人：")
            Picker(selection: $selectedMember, label: Text("member")) {
                ForEach(0..<memberArray.count, id:\.self) { index in
                    Text(memberArray[index])
                }
            }
        }
    }
}

struct PickerMemberView_Previews: PreviewProvider {
    static var previews: some View {
        PickerMemberView(selectedMember: Binding.constant(1),memberArray:[])
    }
}
