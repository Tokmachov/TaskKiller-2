//
//  Month.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol Month {
    var daysCount: Int { get }
    var weeksCount: Int { get }
    var description: String { get }
    init(days: [Day], monthFirstDayDate: Date)
    func day(atIndex index: Int) -> Day
}



