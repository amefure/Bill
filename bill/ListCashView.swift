//
//  ListCashView.swift
//  bill
//
//  Created by t&a on 2022/07/10.
//

import SwiftUI

struct ListCashView: View {

    
    // インスタンス----------------------------------------------------
    // ファイルコントローラークラスをインスタンス化
    let fileController = FileController()
    // 全キャッシュ情報をデータとして持つクラスをインスタンス化
    @ObservedObject var allCashData = AllCashData()
    
    // 親のメソッドを受け取る--------------------------------------------
    var parentRefreshFunction: () -> Void
    
    var body: some View {
        VStack {
            
            // .reversed()：逆順
            List (allCashData.allData.reversed()) { item in
                
                RowCashView(item: item)
                    .swipeActions(edge: .trailing,allowsFullSwipe: false){
                        Button(role:.destructive,action: {
                            
                            // リストの削除処理にゆっくりのアニメーション
                            withAnimation(.linear(duration: 0.3)){
                                
                                allCashData.removeCash(item)   // 選択されたitemを削除
                                fileController.updateJson(allCashData.allData) // JSONファイルを更新
                                allCashData.setAllData() // JSONファイルをプロパティにセット
                                self.parentRefreshFunction() // 親Viewのクラスをリフレッシュ
                                
                            }
                            
                        }, label: {
                            Image(systemName: "trash")
                        })

                        
                    }
            }
        }
    }
}

struct ListCashView_Previews: PreviewProvider {
    static var previews: some View {
        ListCashView(parentRefreshFunction: {})
        // allData: Binding.constant([CashData(cash:4753,memo:"高速代"),CashData(cash:2000,memo:"ガソリン代"),CashData(cash:25000,memo:"旅館（梅小路　花伝沙）")])
    }
}
