//
//  Calendar.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

extension DateComponents {
    init(year: Int, month: Int, weekOfMonth: Int, weekDay: Int) {
        self.init()
        self.year = year
        self.month = month
        self.weekOfMonth = weekOfMonth
        self.weekday = weekDay
    }
}
extension Calendar {
    func monthFirstDayDate(year: Int, monthNumber: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = monthNumber
        let date = self.date(from: dateComponents)
        return date
    }
    
}
