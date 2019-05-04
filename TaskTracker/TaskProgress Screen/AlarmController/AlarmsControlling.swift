//
//  File.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol AlarmsControlling {
    init(delegate: AlarmsControllerDelegate)
    func addTaskTimeOutAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoSource)
    func addBreakTimeOutAlarmThatFiresIn(_ timeinterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoSource)
    func removeTaskTimeOutAlarm()
    func removeBreakTimeOutAlarm()
}

