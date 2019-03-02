//
//  TaskState.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskStateImp: TaskState {
 
    private var stateDelegate: TaskStateDelegate
    private var state: States = .notStarted {
        didSet {
            switch state {
            case .notStarted: break
            case .started(date: let dateStarted):
                stateDelegate.taskState(self, didDidChangeToStartedWith: dateStarted)
            case .stopped:
                stateDelegate.taskSate(self, didChangeToStoppedWithPeriodPassed: taskProgressPeriod!)
            }
        }
    }
    
    private var taskProgressPeriod: ProgressPeriod? {
        guard case let .stopped(started: dateStarted, ended: dateStopped) = state else { return nil }
        return ProgressPeriod.init(dateStarted: dateStarted, dateEnded: dateStopped)
    }
    init(stateSavingDelegate: TaskStateDelegate) {
        self.stateDelegate = stateSavingDelegate
    }
    
    mutating func goToStartedState() {
        if case .started = state { return }
        state = .started(date: Date())
    }
    mutating func goToStoppedState() {
        guard case let .started(date: date) = state else { return }
        state = .stopped(started: date, ended: Date())
    }
 
    mutating func goToNextState() {
        switch state {
        case .notStarted:
            if stateDelegate.canChangeToStarted(self) {
                state = .started(date: Date())
            } else {
                break
            }
        case .started(date: let dateStarted): state = .stopped(started: dateStarted, ended: Date())
        case .stopped:
            if stateDelegate.canChangeToStarted(self) {
                state = .started(date: Date())
            } else {
                break
            }
        }
    }
}

