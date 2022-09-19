//
//  DataManager.swift
//  BasicDiaryApp
//
//  Created by Paul Lee on 2022/09/19.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    private init() { }
    
    var diaryList = [Diary]()
    
    func saveDiaryList() {
        let diaryData = diaryList.map {
            ["title": $0.title, "contents": $0.contents, "createdDate": $0.createdDate, "isStar": $0.isStar]
        }
        UserDefaults.standard.set(diaryData, forKey: "diaryData")
    }
    
    func loadDiaryList(onlyStar: Bool) {
        guard let diaryData = UserDefaults.standard.object(forKey: "diaryData") as? [[String: Any]] else { return }
        
        diaryList = diaryData.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let createdDate = $0["createdDate"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(title: title, contents: contents, createdDate: createdDate, isStar: isStar)
        }
        
        if onlyStar {
            diaryList = diaryList.filter {
                $0.isStar == true
            }
        }
        
        diaryList = diaryList.sorted(by: { first, second in
            first.createdDate.compare(second.createdDate) == .orderedDescending
        })
    }
    
    func addDiary(diary: Diary) {
        diaryList.append(diary)
        saveDiaryList()
    }
}

