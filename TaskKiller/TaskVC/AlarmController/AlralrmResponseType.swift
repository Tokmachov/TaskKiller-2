//
//  AlralrmResponseType.swift
//  TaskKiller
//
//  Created by mac on 14/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

enum AlarmResponseType {
    case addWorkTime(TimeInterval)
    case addBreak(TimeInterval)
    case finishTask
    case defaultAlarmResponse
    case noAdditionalTimesSet
}
