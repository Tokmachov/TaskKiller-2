//
//  RepresentableInSectionedTable.swift
//  TaskKiller
//
//  Created by mac on 24/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
protocol RepresentableInSectionedTable {
    var numberOfAdditionalTimesTypes: Int { get }
    var titleForAdditionalWorkTimesSection: String { get }
    var titleForAdditionalBreakTimesSection: String { get }
    var additionalWorkTimes: [AdditionalTime] { get }
    var additionalBreakTimes: [AdditionalTime] { get }
}
