//
//  TaskState.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskState: TaskStatable, TaskProgressTimesGetable {
   
    private var state: States
    private var timeSpentInProgress: TimeInterval
    private var postponableDeadLine: TimeInterval
    
    private var progressTimes: TaskProgressTimes {
        set {
          timeSpentInProgress = newValue.timeSpentInprogress
            postponableDeadLine = newValue.currentDeadLine
        }
        get {
            return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: postponableDeadLine)
        }
    }
    
    //MARK: TaskStatable
    init(taskProgressTimes: TaskProgressTimes) {
        self.timeSpentInProgress = taskProgressTimes.timeSpentInprogress
        self.postponableDeadLine = taskProgressTimes.currentDeadLine
        self.state = States.hasNotStarted
    }
    
    mutating func changeState() {
        switch state {
        case .hasNotStarted:
            let currentDate = Date()
            state = .started(datesStarted: currentDate)
        case .started(datesStarted: let date):
            let currentDate = Date()
            state = .ended(datesStarted: date, dateEnded: currentDate)
        case .ended(datesStarted: _, dateEnded: _):
            let currentDate = Date()
            state = .started(datesStarted: currentDate)
        }
    }
    func getCurrentState() -> States {
        return state
    }
    mutating func updateTimeSpentInProgress(_ newTime: TimeInterval) {
        self.timeSpentInProgress = newTime
    }
    
    mutating func postponeDeadLine(for time: TimeInterval) {
        self.postponableDeadLine += time
    }
    //MARK: TaskProgressTimesGetable
    func getProgressTimes() -> TaskProgressTimes {
        return progressTimes
    }
}
