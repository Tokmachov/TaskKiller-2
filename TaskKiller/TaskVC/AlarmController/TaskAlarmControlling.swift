//
//  File.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskAlarmControlling {
    func addAlarmThatFiresIn(_ timeInterval: TimeInterval, forTask task: Task)
    func removeAlarm()
}

