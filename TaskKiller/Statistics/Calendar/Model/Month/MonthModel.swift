//
//  Month.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol MonthModel {
    var numberOfDayModels: Int { get }
    var weeksCount: Int { get }
    var monthAndYearDescription: String { get }
    init(days: [DayModel], monthFirstDayDate: Date)
}


