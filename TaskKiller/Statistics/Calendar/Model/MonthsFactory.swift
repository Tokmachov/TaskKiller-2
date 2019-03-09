//
//  DaysMaker.swift
//  TaskKiller
//
//  Created by mac on 08/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthsFactory {
    static func makeMonths(startYear: Int, endYear: Int) -> [Month] {
        guard endYear > startYear else { fatalError() }
        var months = [Month]()
        for year in startYear...endYear {
            months += makeMonths(year: year)
        }
        return months
    }
    
    static private func makeMonths(year: Int) -> [Month] {
        let monthNumbers = 1...12
        var months = [Month]()
        for monthNumber in monthNumbers {
            let month = makeMonth(year: year, monthNumber: monthNumber)
            months.append(month)
        }
        return months
    }
    
    static private func makeMonth(year: Int, monthNumber: Int) -> Month {
        let days = makeDays(year: year, monthOfYear: monthNumber)
        let monthFirstDayDate = Calendar.current.monthFirstDayDate(year: year, monthNumber: monthNumber)!
        let month = MonthImp(days: days, monthFirstDayDate: monthFirstDayDate)
        return month
    }
    
    static private func makeDays(year: Int, monthOfYear: Int) -> [Day] {
        let monthDate = Calendar.current.monthFirstDayDate(year: year, monthNumber: monthOfYear)!
        let weeksOfMonth = Calendar.current.range(of: .weekOfMonth, in: .month, for: monthDate)!
        let daysOfWeek = 1...7
        var dates = [Date]()
        for weekOfMonth in weeksOfMonth {
            for weekDay in daysOfWeek {
                let date = dateForWeekDay(year: year, month: monthOfYear, weekOfMonth: weekOfMonth, weekDay: weekDay)
                dates.append(date)
            }
        }
        
        let days: [Day] = dates.map { (date) -> Day in
            let monthDateBelongsTo = Calendar.current.component(.month, from: date)
            if monthDateBelongsTo == monthOfYear {
                let dayOfMonth = Calendar.current.component(.day, from: date)
                return ValidDay(dayNumber: dayOfMonth, workHours: nil)
            } else {
                return PlaceHolderDay()
            }
        }
        return days
    }
    static private func dateForWeekDay(year: Int, month: Int, weekOfMonth: Int, weekDay: Int) -> Date {
        let dateComponents = DateComponents(year: year, month: month, weekOfMonth: weekOfMonth, weekDay: weekDay)
        let date = Calendar.current.date(from: dateComponents)
        return date!
    }
    
}

