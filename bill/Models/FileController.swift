//
//  FileController.swift
//  bill
//
//  Created by t&a on 2022/07/04.
//

import Foundation


// 請求金額を蓄積するためのFileController
class FileController {
    
    // Documents内で操作するJSONファイル名
    private let cashFileName:String = "CashData.json"
    private let eventFileName:String = "EventData.json"
    // Documents内で追加できるロケーション数を格納
    private let txtName:String = "LimitNum.txt"
    // デフォルト制限数
    private let defaultLimit:String = "3"
    private let addLimitNum:Int = 3
    
    // 保存ファイルへのURLを作成 file::Documents/fileName
    func docURL(_ fileName:String) -> URL? {
        let fileManager = FileManager.default
        do {
            // Docmentsフォルダ
            let docsUrl = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            // URLを構築
            let url = docsUrl.appendingPathComponent(fileName)
            
            return url
        } catch {
            return nil
        }
    }
    // 操作するJsonファイルがあるかどうか
    func hasFile (_ fileName:String) -> Bool{
        let str =  NSHomeDirectory() + "/Documents/" + fileName
        if FileManager.default.fileExists(atPath: str) {
            return true
        }else{
            return false
        }
    }
    
    // 念の為数値かチェック
    private func numCheck (_ str:String) -> Bool{
        guard Int(str) != nil else {
            return false // 文字列の場合
        }
        return true // 数値の場合
    }
    
    // MARK: - Cashdata
    // ファイル削除処理
    func clearFile() {
        guard let url = docURL(cashFileName) else {
            return
        }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
        }
    }
    
    // 登録する一件のキャッシュデータを受け取る
    // 現在のキャッシュALL情報を取得し構造体に変換してから追加
    // 再度JSONに直し書き込み
    func saveJson(_ cash:CashData) {
        guard let url = docURL(cashFileName) else {
            return
        }
        
        var cashArray:[CashData]
        
        cashArray = loadJson() // [] or [CashData]
        cashArray.append(contentsOf: [cash]) // いずれにせよ追加処理
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(cashArray)
        let jsonData = String(data:data, encoding: .utf8)!
        
        do {
            // ファイルパスへの保存
            let path = url.path
            try jsonData.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    // ListCashViewからremoveされたデータを保存する
    func updateJson(_ allCash:[CashData]) {
        guard let url = docURL(cashFileName) else {
            return
        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(allCash)
        let jsonData = String(data:data, encoding: .utf8)!
        
        do {
            // ファイルパスへの保存
            let path = url.path
            try jsonData.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    // JSONデータを読み込んで[構造体]にする
    func loadJson() -> [CashData] {
        guard let url = docURL(cashFileName) else {
            return []
        }
        if hasFile(cashFileName) {
            // JSONファイルが存在する場合
            let jsonData = try! String(contentsOf: url).data(using: .utf8)!
            let cashArray = try! JSONDecoder().decode([CashData].self, from: jsonData)
            return cashArray
        }else{
            // JSONファイルが存在しない場合
            return []
        }
    }
    // MARK: - Cashdata
    // MARK: - Eventdata
    func clearEventFile() {
        guard let url = docURL(eventFileName) else {
            return
        }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
        }
    }
    
    
    // 登録する一件のキャッシュデータを受け取る
    // 現在のキャッシュALL情報を取得し構造体に変換してから追加
    // 再度JSONに直し書き込み
    func saveEventJson(_ event:EventData) {
        guard let url = docURL(eventFileName) else {
            return
        }
        
        var eventArray:[EventData]
        
        eventArray = loadEventJson() // [] or [CashData]
        eventArray.append(contentsOf: [event]) // いずれにせよ追加処理
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(eventArray)
        let jsonData = String(data:data, encoding: .utf8)!
        
        do {
            // ファイルパスへの保存
            let path = url.path
            try jsonData.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    // ListCashViewからremoveされたデータを保存する
    func updateEventJson(_ allevent:[EventData]) {
        guard let url = docURL(eventFileName) else {
            return
        }
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(allevent)
        let jsonData = String(data:data, encoding: .utf8)!
        
        do {
            // ファイルパスへの保存
            let path = url.path
            try jsonData.write(toFile: path, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print(error)
        }
    }
    
    // JSONデータを読み込んで[構造体]にする
    func loadEventJson() -> [EventData] {
        guard let url = docURL(eventFileName) else {
            return []
        }
        if hasFile(eventFileName) {
            // JSONファイルが存在する場合
            let jsonData = try! String(contentsOf: url).data(using: .utf8)!
            let eventArray = try! JSONDecoder().decode([EventData].self, from: jsonData)
            return eventArray
        }else{
            // JSONファイルが存在しない場合
            return []
        }
    }
    
    // LimitNum.txt---------------------------------------
    func loadLimitTxt() -> Int {
        
        guard let url = docURL(txtName) else {
            return Int(defaultLimit)!
        }
        
        do {
            if hasFile(txtName) {
                let currentLimit = try String(contentsOf: url, encoding: .utf8)
                
                if numCheck(currentLimit) {
                    return Int(currentLimit)!
                }else{
                    return Int(defaultLimit)!
                }
                
            }else{
                try defaultLimit.write(to: url,atomically: true,encoding: .utf8)
                return Int(defaultLimit)!
            }
            
        } catch{
            // JSONファイルが存在しない場合
            return Int(defaultLimit)!
        }
        
    }
    
    func addLimitTxt(){
        guard let url = docURL(txtName) else {
            return
        }
        do {
                var currentLimit = try String(contentsOf: url, encoding: .utf8)
                
                if numCheck(currentLimit) {
                    currentLimit = String(Int(currentLimit)! + addLimitNum)
                    try currentLimit.write(to: url,atomically: true,encoding: .utf8)
                }
            
        } catch{
            return
        }
        
    }
}

