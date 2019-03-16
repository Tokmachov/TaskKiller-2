//
//  DaysMaker.swift
//  TaskKiller
//
//  Created by mac on 08/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthsModelsFactory {
    static func makeMonthModelsStore(startYear: Int, endYear: Int) -> MonthsModelsStore {
        guard endYear > startYear else { fatalError() }
        var months = [MonthModel]()
        for year in startYear...endYear {
            months += makeMonthsModels(year: year)
        }
        let store = MonthsModelsStoreImp(months: months)
        return store
    }
    
    static private func makeMonthsModels(year: Int) -> [MonthModel] {
        let monthsRange = 1...12
        var monthsModels = [MonthModel]()
        for month in monthsRange {
            let monthModel = makeMonthModel(year: year, month: month)
            monthsModels.append(monthModel)
        }
        return monthsModels
    }
    
    static private func makeMonthModel(year: Int, month: Int) -> MonthModel {
        let days = makeDays(year: year, month: month)
        let monthFirstDayDate = Calendar.current.monthFirstDayDate(year: year, monthNumber: month)!
        let month = MonthModelImp(days: days, monthFirstDayDate: monthFirstDayDate)
        return month
    }
    
    static private func makeDays(year: Int, month: Int) -> [DayModel] {
        let monthDate = monthDateFor(year: year, AndMonth: month)
        let weeksOfMonthRange = weaksOfMonthRangeFor(monthDate: monthDate)
        let datesOfDays = datesForDaysFrom(weeksRange: weeksOfMonthRange, ofMonth: month, AndYear: year)
        let days = datesToDays(datesOfDays, monthOfYear: month)
        return days
    }
    static private func monthDateFor(year: Int, AndMonth month: Int) -> Date {
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
    static func datesToDays(_ dates: [Date], monthOfYear: Int) -> [DayModel] {
        let days: [DayModel] = dates.map { (date) -> DayModel in
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

