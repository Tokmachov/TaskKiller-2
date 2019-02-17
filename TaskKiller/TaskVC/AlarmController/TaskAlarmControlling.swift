//
//  File.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskAlarmControlling {
    init(alarmReceivingDelegate: TaskAlarmsReceivingDelegate)
    func addTaskTimeOutAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoCreating)
    func addBreakTimeOutAlarmThatFiresIn(_ timeinterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoCreating)
    func removeAlarm()
}

