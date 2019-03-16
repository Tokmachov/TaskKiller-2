//
//  MonthStore.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol MonthsModelsStore {
    var numberOfMonthsModels: Int { get }
    var maximumNumberOfWeeksInMonth: Int { get }
    init(months: [MonthModel])
    func numberOfDayModelsInMonthModel(atIndex index: Int) -> Int
    func monthModel(atIndex index: Int) -> MonthModel
    func numberOfWeeksMonthModelsWeekCountIsBelowMaximumWeekCount(monthModelIndex: Int) -> Int
}
