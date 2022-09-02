//
//  RewordView.swift
//  bill
//
//  Created by t&a on 2022/09/02.
//

import SwiftUI

struct RewordView: View {
    // MARK: - AdMob reward広告
    @ObservedObject var reward = Reward()
    @State var isAlertReward:Bool = false    // リワード広告視聴回数制限アラート
    @AppStorage("LastAcquisitionDate") var lastAcquisitionDate = ""
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct RewordView_Previews: PreviewProvider {
    static var previews: some View {
        RewordView()
    }
}
