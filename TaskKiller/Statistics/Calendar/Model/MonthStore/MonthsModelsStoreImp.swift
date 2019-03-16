//
//  MOnthStoreIm.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthsModelsStoreImp: MonthsModelsStore {
 
    private var monthsModels: [MonthModel]
    
    var numberOfMonthsModels: Int {
        return monthsModels.count
    }
    var maximumNumberOfWeeksInMonth: Int {
        return maximumWeeksCountInAllMonthModels
    }
    init(months: [MonthModel]) {
        self.monthsModels = months
    }
    func numberOfDayModelsInMonthModel(atIndex index: Int) -> Int {
        return monthsModels[index].numberOfDayModels
    }
    func monthModel(atIndex index: Int) -> MonthModel {
        return monthsModels[index]
    }
    func numberOfWeeksMonthModelsWeekCountIsBelowMaximumWeekCount(monthModelIndex: Int) -> Int {
        return maximumWeeksCountInAllMonthModels - monthsModels[monthModelIndex].weeksCount
    }
    private var maximumWeeksCountInAllMonthModels: Int {
        return monthsModels.map { $0.weeksCount }.max()!
    }
}
