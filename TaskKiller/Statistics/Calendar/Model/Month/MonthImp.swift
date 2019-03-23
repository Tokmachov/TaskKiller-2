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
    private var days: [Day]
    private var dayForHorisontalDisplay: [Day] {
        let weeks = splitMonthToWeeks(month: days)
        var daysSortedByDayNumberArrays = [[Day]]()
        for weekDayNumber in 0...6 {
            let daysOfMonthWithOneWeekNumber = filterOutWeekDay(number: weekDayNumber, outOfWeeks: weeks)
            daysSortedByDayNumberArrays.append(daysOfMonthWithOneWeekNumber)
        }
       var outPutArray = [Day]()
        for daysSortedByDayNumber in daysSortedByDayNumberArrays {
            outPutArray += daysSortedByDayNumber
        }
        return outPutArray
    }
    private func splitMonthToWeeks(month: [Day]) -> [[Day]] {
        guard monthHasIntegerWeekCount(month) else { fatalError() }
        var week = [Day]()
        var weeks = [[Day]]()
        for day in month {
            week.append(day)
            if week.count == 7 {
                weeks.append(week)
                week = []
            }
        }
        return weeks
    }
    
    private func monthHasIntegerWeekCount(_ month: [Day]) -> Bool {
        return month.count % 7 == 0
    }
    
    private func filterOutWeekDay(number weekDayNumber: Int, outOfWeeks weeks: [[Day]]) -> [Day] {
        return weeks.map { $0[weekDayNumber] }
    }
    
    //MARK: Month
    var description: String {
        return dateFormatter.string(from: monthsFirstDayDate)
    }
    var daysCount: Int {
        return days.count
     }
    var weeksCount: Int {
        return  daysCount / 7
    }
    init(days: [Day], monthFirstDayDate: Date) {
        self.days = days
        self.monthsFirstDayDate = monthFirstDayDate
    }
    func dayModel(atIndex index: Int) -> Day {
        return days[index]
    }
    func day(atIndex index: Int) -> Day {
        return dayForHorisontalDisplay[index]
    }
}
