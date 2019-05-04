//
//  TaskStateChangesReceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 21/11/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStateDelegate: AnyObject {
    func taskState(_ taskState: TaskState, didDidChangeToStartedWith date: Date)
    func taskState(_ taskState: TaskState, didChangeToStoppedWithPeriodPassed period: ProgressPeriod)
    func canChangeToStarted(_ taskState: TaskState) -> Bool
}
