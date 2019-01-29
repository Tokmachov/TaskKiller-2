//
//  TaskStateChangesReceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 21/11/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStateDelegate: AnyObject {
    func saveTaskProgressPeriod(_ period: TaskProgressPeriod)
    func stateDidChangedToNotStarted()
    func stateDidChangedToStarted()
}
