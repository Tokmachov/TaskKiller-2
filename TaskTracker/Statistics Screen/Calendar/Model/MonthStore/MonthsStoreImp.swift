//
//  MOnthStoreIm.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthsStoreImp: MonthsStore {
    var monthCount: Int {
        return monthsModels.count
    }
    func month(atIndex index: Int) -> Month {
        return monthsModels[index]
    }
    var maximumWeekCountInAllMonths: Int {
        return monthsModels.map { $0.weeksCount }.max()!
    }
    func weekCountInMonth(atIndex index: Int) -> Int {
        return monthsModels[index].weeksCount
    }
    private var monthsModels: [Month]
    init(months: [Month]) {
        self.monthsModels = months
    }
}
