//
//  MonthStore.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol MonthsStore {
    var monthCount: Int { get }
    var maximumWeekCountInAllMonths: Int { get }
    func weekCountInMonth(atIndex index: Int) -> Int
    func month(atIndex index: Int) -> Month
}
