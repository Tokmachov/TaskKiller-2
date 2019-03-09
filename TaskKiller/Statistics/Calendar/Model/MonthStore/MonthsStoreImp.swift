//
//  MOnthStoreIm.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct MonthsStoreImp: MonthsStore {
    var months: [Month]
    init(months: [Month]) {
        self.months = months
    }
}
