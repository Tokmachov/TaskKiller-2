//
//  Month.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol Month {
    var monthNameAndYear: String { get }
    var days: [Day] { get }
    init(days: [Day], monthFirstDayDate: Date)
}
