//
//  EventData.swift
//  bill
//
//  Created by t&a on 2022/08/29.
//

import Foundation

struct EventData: Identifiable,Codable,Equatable {
    
    var id = UUID()             // 一意の値
    var name:String             // イベント名
    var member:[String]         // メンバー
    var cashData:[CashData]    // キャッシュデータ
    var time:String = {         // 初期値に現在の日付
        
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateStyle = .short
        df.timeStyle = .none
        
        return df.string(from: Date())

    }()
}

// -------------------------------------------------------------

class AllEventData:ObservableObject{
    
    // プロパティ-------------------------------------------------
    @Published var allData:[EventData] = [] // 全情報
    
    // プロパティに値をセット---------------------------------------
    init(){
        // 初期値を入れていないとメソッドは実行できないためプロパティでも初期値有
        self.setAllData()
    }
    
    // メソッド---------------------------------------------------
    
    // JSONファイルに格納されている全キャッシュ情報をプロパティにセット
    func setAllData(){
        let f = FileController()
        self.allData = f.loadEventJson()
    }

    func removeCash(_ item:EventData) {
        guard let index = allData.firstIndex(of:item) else { return }
        allData.remove(at: index)
    }
}

