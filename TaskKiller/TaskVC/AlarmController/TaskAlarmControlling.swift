//
//  File.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskAlarmControlling {
    init(alarmReceivingDelegate: TaskTimeOutAlarmReceivingDelegate)
    func addAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoCreating)
    func removeAlarm()
}

