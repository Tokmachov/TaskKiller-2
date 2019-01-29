//
//  TaskState.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskStateImp: TaskState {
    
    private var state: States = .notStarted
    private var stateDelegate: TaskStateDelegate
    
    init(stateSavingDelegate: TaskStateDelegate) {
        self.stateDelegate = stateSavingDelegate
    }
    
    mutating func saveState() {
        guard let period = getProgressPeriod() else { return }
        refreshState()
        stateDelegate.saveTaskProgressPeriod(period)
    }

    mutating func goToNextState() {
        switch state {
        case .notStarted:
            state = .started(datesStarted: Date())
            stateDelegate.stateDidChangedToStarted()
        case .started:
            state = .notStarted
            stateDelegate.stateDidChangedToNotStarted()
        }
    }
    private func getProgressPeriod() -> TaskProgressPeriod? {
        switch state {
        case .notStarted: return nil
        case .started(datesStarted: let dateStarted):
            let period = TaskProgressPeriod.init(dateStarted: dateStarted, dateEnded: Date())
            return period
        }
    }
    private mutating func refreshState() {
        switch state {
        case .notStarted: break
        case .started: self.state = .started(datesStarted: Date())
        }
    }
}
