//
//  TaskStateChangesReceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 21/11/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStateDelegate: AnyObject {
    func statedDidChangeToStarted(dateStarted: Date)
    func stateDidChangeToStopped(progressPeriodToSave: TaskProgressPeriod)
    func canChangeToStarted() -> Bool
}
