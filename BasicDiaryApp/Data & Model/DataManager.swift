//
//  DataManager.swift
//  BasicDiaryApp
//
//  Created by Paul Lee on 2022/09/19.
//

import Foundation

extension NSNotification.Name {
    static let DiaryAdded = NSNotification.Name("DiaryAddedNotification")
    static let DiaryEdited = NSNotification.Name("DiaryEditedNotification")
    static let DiaryDeleted = NSNotification.Name("DiaryDeletedNotification")
    static let DiaryStared = NSNotification.Name("DiaryStared")
}

class DataManager {
    static let shared = DataManager()
    private init() { }
    
    var diaryList = [Diary]()
    var starDiaryList: [Diary] {
        return diaryList.filter {
            $0.isStar == true
        }
    }
    
    func saveDiaryList() {
        diaryList = diaryList.sorted(by: { first, second in
            first.createdDate.compare(second.createdDate) == .orderedDescending
        })
        
        let diaryData = diaryList.map {
            ["uuidString": $0.uuidString, "title": $0.title, "contents": $0.contents, "createdDate": $0.createdDate, "isStar": $0.isStar]
        }
        UserDefaults.standard.set(diaryData, forKey: "diaryData")
    }
    
    func loadDiaryList() {
        guard let diaryData = UserDefaults.standard.object(forKey: "diaryData") as? [[String: Any]] else { return }
        
        diaryList = diaryData.compactMap {
            guard let uuidString = $0["uuidString"] as? String else { return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let createdDate = $0["createdDate"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(uuidString: uuidString, title: title, contents: contents, createdDate: createdDate, isStar: isStar)
        }
    }
    
    func addDiary(diary: Diary) {
        diaryList.append(diary)
        saveDiaryList()
        NotificationCenter.default.post(name: NSNotification.Name.DiaryAdded, object: nil)
    }
    
    func updateDiary(diary: Diary) {
        guard let index = diaryList.firstIndex(where: {
            $0.uuidString == diary.uuidString
        }) else { return }
        diaryList[index] = diary
        saveDiaryList()
        NotificationCenter.default.post(name: NSNotification.Name.DiaryEdited, object: diary)
    }
    
    func deleteDiary(diary: Diary) {
        guard let index = diaryList.firstIndex(where: {
            $0.uuidString == diary.uuidString
        }) else { return }
        diaryList.remove(at: index)
        saveDiaryList()
        NotificationCenter.default.post(name: NSNotification.Name.DiaryDeleted, object: nil)
    }
    
    func starDiary(diary: Diary) {
        updateDiary(diary: diary)
    }
}

