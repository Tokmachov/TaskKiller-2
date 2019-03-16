//
//  MonthImp.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthModelImp: MonthModel {

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.locale = Locale.current
        formatter.dateFormat = "MMMM yy"
        return formatter
    }()
    private var monthsFirstDayDate: Date
    private var days: [DayModel]
    
    //MARK: MonthModel
    var monthAndYearDescription: String {
        return dateFormatter.string(from: monthsFirstDayDate)
    }
    var numberOfDayModels: Int {
        return days.count
    }
    var weeksCount: Int {
        return numberOfDayModels / 7
    }
    init(days: [DayModel], monthFirstDayDate: Date) {
        self.days = days
        self.monthsFirstDayDate = monthFirstDayDate
    }
}
