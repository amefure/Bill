//
//  HistoryEventView.swift
//  bill
//
//  Created by t&a on 2022/08/29.
//

import SwiftUI

struct HistoryEventView: View {
    // MARK: -
    let fileController = FileController()
    @EnvironmentObject var allEventData:AllEventData
    
    var body: some View {
        NavigationView{
            VStack{
                
                // MARK: -
                List (allEventData.allData.reversed()) { item in
                    RowEventView(item: item)
                        .swipeActions(edge: .trailing,allowsFullSwipe: false){
                            Button(role:.destructive,action: {
                                // リストの削除処理にゆっくりのアニメーション
                                withAnimation(.linear(duration: 0.3)){
                                    allEventData.removeCash(item)   // 選択されたitemを削除
                                    fileController.updateEventJson(allEventData.allData) // JSONファイルを更新
                                    allEventData.setAllData() // JSONファイルをプロパティにセット
                                }
                            }, label: {
                                Image(systemName: "trash")
                            })
                        }
                }.navigationTitle("イベント履歴")
                .listStyle(GroupedListStyle()) // Listのスタイルを横に広げる
                // MARK: -
                
                // MARK: - 容量追加
                RewardButtonView()
                // MARK: - 容量追加
                
            }
        }
    }
}

struct HistoryEventView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryEventView()
    }
}
