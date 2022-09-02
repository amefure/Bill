//
//  ContentView.swift
//  bill
//
//  Created by t&a on 2022/07/04.
//

import SwiftUI
import GoogleMobileAds


struct ContentView: View {
    
    // MARK: - View
    
    @State var selectedTag:Int = 1      //  タブビュー
    
    // MARK: - AppStorage
    @AppStorage("eventName") var eventName:String = "" // イベント名
    @AppStorage("member") var member:String = ""  // 配列が格納できないため文字列で保存 "Tom,Johnny,Joseph"
    // memberArrayに配列形式で保持
    @State var memberArray:[String] = [""]
    
    // MARK: - インスタンス
    // ファイルコントローラークラスをインスタンス化
    let fileController = FileController()
    // 全キャッシュ情報をデータとして持つクラスをインスタンス化
    
    @ObservedObject var allCashData = AllCashData()
    @ObservedObject var allEventData = AllEventData()
    
    // MARK: - Boolプロパティ
    @State var isEvent:Bool = false // 旅行イベントを作成したかどうか

    
    // MARK: - メソッド
    func storageReset(){
        eventName = ""
        member = ""
        memberArray = [""]
        isEvent = false
    }
    
    var body: some View {
        TabView(selection: $selectedTag){
            
            // MARK: - タブ1 イベント作成画面 or 登録画面
            Group{
                if !isEvent {
                   CreateEvent(isEvent: $isEvent, memberArray: $memberArray)
                }else{
                    EntryCashView(eventName:$eventName,memberArray:$memberArray,parentStorageResetFunction:storageReset).environmentObject(allCashData).environmentObject(allEventData)
                }
            }
            .tabItem{
                
                Image(systemName: "pencil.circle")
                Text("Event")
                
            }.tag(1)
            
            // MARK: - タブ2　割り勘計算View
            HistoryEventView().environmentObject(allEventData).tabItem{
                Image(systemName: "list.bullet.circle.fill")
                Text("History")
            }.tag(2)
        }
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .navigationViewStyle(.stack)
        .ignoresSafeArea()
        .accentColor(.orange)
        .onAppear{
            if member != "" {
                memberArray = member.components(separatedBy: ",")
                isEvent = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
