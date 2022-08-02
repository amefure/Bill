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
    private let jsonName:String = "cashData.json"
    
    // 保存ファイルへのURLを作成 file::Documents/fileName
    func docURL() -> URL? {
        let fileManager = FileManager.default
        do {
            // Docmentsフォルダ
            let docsUrl = try fileManager.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            // URLを構築
            let url = docsUrl.appendingPathComponent(jsonName)
            
            return url
        } catch {
            return nil
        }
    }


    // ファイル削除処理
    func clearFile() {
        guard let url = docURL() else {
            return
        }
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
        }
    }
    
    
    // 操作するJsonファイルがあるかどうか
    func hasJson () -> Bool{
        
        let str =  NSHomeDirectory() + "/Documents/" + jsonName
        if FileManager.default.fileExists(atPath: str) {
            return true
        }else{
            return false
        }
    }
    
    // 登録する一件のキャッシュデータを受け取る
    // 現在のキャッシュALL情報を取得し構造体に変換してから追加
    // 再度JSONに直し書き込み
    func saveJson(_ cash:CashData) {
        guard let url = docURL() else {
            
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
        guard let url = docURL() else {
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
        
        guard let url = docURL() else {
            return []
        }
        
        if hasJson() {
            // JSONファイルが存在する場合
            let jsonData = try! String(contentsOf: url).data(using: .utf8)!
            let cashArray = try! JSONDecoder().decode([CashData].self, from: jsonData)
            return cashArray
            
        }else{
            // JSONファイルが存在しない場合
            return []
            
        }
        


    }
    
}

