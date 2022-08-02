//
//  CashData.swift
//  bill
//
//  Created by t&a on 2022/07/06.
//

import Foundation

struct CashData: Identifiable,Codable,Equatable {
    // Identifiable：List表示のため
    // Codable：JSONエンコード/デコード
    // Equatable；firstIndexを使用可能にするため
    // キャッシュ情報を統括して管理する構造体

    var id = UUID()             // 一意の値
    var cash:Int                // 金額情報
    var memo:String = ""        // MEMO
    var time:String = { // 初期値に現在の日付
        
        let df = DateFormatter()
        df.calendar = Calendar(identifier: .gregorian)
        df.locale = Locale(identifier: "ja_JP")
        df.timeZone = TimeZone(identifier: "Asia/Tokyo")
        df.dateStyle = .none
        df.timeStyle = .short
        
        return df.string(from: Date())

    }()
}

// -------------------------------------------------------------

class AllCashData:ObservableObject{
    // 全キャッシュ情報をデータとして持つクラス
    //ObservableObjectプロトコル→プロパティの値を監視
    
    // プロパティ-------------------------------------------------
    @Published var allData:[CashData] = [] // 全情報
    @Published var bill:Int = 0  // 請求金額の合計
    
    // プロパティに値をセット---------------------------------------
    init(){
        // 初期値を入れていないとメソッドは実行できないためプロパティでも初期値有
        self.setAllData()
        self.sumBill()
    }
    
    
    // メソッド---------------------------------------------------
    
    // JSONファイルに格納されている全キャッシュ情報をプロパティにセット
    func setAllData(){
        let f = FileController()
        self.allData = f.loadJson()
    }
    
    // 現在の合計金額を格納
    func sumBill(){
        var result:Int = 0
        for item in self.allData{
            result += item.cash
        }
        self.bill = result
    }
    
    // Equatableを準拠
    // Referencing instance method 'firstIndex(of:)' on 'Collection' requires that 'CashData' conform to 'Equatable'
    func removeCash(_ item:CashData) {
        guard let index = allData.firstIndex(of:item) else { return }
        allData.remove(at: index)
    }
}

