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
        let monthsRange = 1...12
        var months = [Month]()
        for month in monthsRange {
            let month = makeMonth(year: year, month: month)
            months.append(month)
        }
        return months
    }
    
    static private func makeMonth(year: Int, month: Int) -> Month {
        let days = makeDays(year: year, month: month)
        let monthFirstDayDate = Calendar.current.monthFirstDayDate(year: year, monthNumber: month)!
        let month = MonthImp(days: days, monthFirstDayDate: monthFirstDayDate)
        return month
    }
    
    static private func makeDays(year: Int, month: Int) -> [Day] {
        let monthDate = monthDateFor(year: year, AndMonthOfYear: month)
        let weeksOfMonthRange = weaksOfMonthRangeFor(monthDate: monthDate)
        let datesOfDays = datesForDaysFrom(weeksRange: weeksOfMonthRange, ofMonth: month, AndYear: year)
        let days = datesToDays(datesOfDays, monthOfYear: month)
        return days
    }
    static private func monthDateFor(year: Int, AndMonthOfYear month: Int) -> Date {
        let validMonthOfYearRange = 1...12
        guard validMonthOfYearRange.contains(month) else { fatalError() }
        let monthDate = Calendar.current.monthFirstDayDate(year: year, monthNumber: month)!
        return monthDate
    }
    static private func weaksOfMonthRangeFor(monthDate: Date) -> Range<Int> {
        return Calendar.current.range(of: .weekOfMonth, in: .month, for: monthDate)!
        
    }
    static private func datesForDaysFrom(weeksRange: Range<Int>,ofMonth month: Int, AndYear year: Int) -> [Date] {
        let daysOfWeekRange = 1...7
        var dates = [Date]()
        for weekOfMonth in weeksRange {
            for day in daysOfWeekRange {
                let date = dateForWeekDay(year: year, month: month, weekOfMonth: weekOfMonth, weekDay: day)
                dates.append(date)
            }
        }
        return dates
    }
    static func datesToDays(_ dates: [Date], monthOfYear: Int) -> [Day] {
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

