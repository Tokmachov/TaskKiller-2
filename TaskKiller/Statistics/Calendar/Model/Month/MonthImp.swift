//
//  MonthImp.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthImp: Month {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM yy"
        return formatter
    }()
    private var monthsFirstDayDate: Date
    
    var monthNameAndYear: String {
        return dateFormatter.string(from: monthsFirstDayDate)
    }
    var days: [Day]
    init(days: [Day], monthFirstDayDate: Date) {
        self.days = days
        self.monthsFirstDayDate = monthFirstDayDate
    }
}
