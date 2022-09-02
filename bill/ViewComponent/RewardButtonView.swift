//
//  RewardButtonView.swift
//  bill
//
//  Created by t&a on 2022/09/02.
//

import SwiftUI

struct RewardButtonView: View {
    let fileController = FileController()
    // MARK: - AdMob reward広告
    @ObservedObject var reward = Reward()
    @State var isAlertReward:Bool = false    // リワード広告視聴回数制限アラート
    @AppStorage("LastAcquisitionDate") var lastAcquisitionDate = ""
    var body: some View {
        VStack{
            ButtonView(parentFunction: {
                // 1日1回までしか視聴できないようにする
                if lastAcquisitionDate != reward.nowTime() {
                    reward.showReward()          //  広告配信
                    fileController.addLimitTxt() // 報酬獲得
                    lastAcquisitionDate = reward.nowTime() // 最終視聴日を格納
                    
                }else{
                    isAlertReward = true
                }
            }, text: "広告を見て\n保存容量を追加する", disable: Binding.constant(false), size: 200)
            Text("Event：\(fileController.loadLimitTxt())")
        }.background(.clear)
        
        .onAppear() {
            reward.loadReward()
        }
        .disabled(!reward.rewardLoaded)
        .alert(isPresented: $isAlertReward){
            Alert(title:Text("お知らせ"),
                  message: Text("広告を視聴できるのは1日に1回までです"),
                  dismissButton: .default(Text("OK"),
                                          action: {}))
        }.padding(.bottom,30)
    }
}

struct RewardButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RewardButtonView()
    }
}
