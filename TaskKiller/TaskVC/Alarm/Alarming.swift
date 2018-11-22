//
//  Alarming.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 15.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation


protocol Alarming {
    
    init(alarmReceiver: AlarmReceiving)
    mutating func setAlarmClockCurrentAndFireTimes(from progressTimesSource: TaskProgressTimesGetable)
    mutating func incrementCurrentTime(_ timeIncrement: TimeInterval)
    mutating func postponeFireTime(for time: TimeInterval)
}
