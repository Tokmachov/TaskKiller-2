//
//  MonthStore.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol MonthsStore {
    var months: [Month] { get }
    init(months: [Month])
}
