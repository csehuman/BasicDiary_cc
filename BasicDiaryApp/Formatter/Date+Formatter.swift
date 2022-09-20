//
//  Date+Formatter.swift
//  BasicDiaryApp
//
//  Created by Paul Lee on 2022/09/20.
//

import Foundation

fileprivate let formatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "ko_KR")
    f.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
    return f
}()


extension Date {
    var dateString: String {
        return formatter.string(from: self)
    }
}


