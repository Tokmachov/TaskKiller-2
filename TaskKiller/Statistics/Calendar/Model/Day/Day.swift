//
//  Day.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
protocol Day {
    var dayNumberDescription: String { get }
    var workHoursDescriotion: String { get }
    var dayType: DayType { get }
}
