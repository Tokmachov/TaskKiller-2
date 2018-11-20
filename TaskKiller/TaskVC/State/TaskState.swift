//
//  TaskState.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskState: ITaskState {
  
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
    init(taskProgressTimesSource: TaskProgressTimesGetable) {
        let taskProgressTimes = taskProgressTimesSource.getProgressTimes()
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
    
    mutating func postponeCurrentDeadline(for additionalTime: TimeInterval) {
        self.postponableDeadLine += additionalTime
    }
    
    //MARK: TaskProgressTimesGetable
    func getProgressTimes() -> TaskProgressTimes {
        return progressTimes
    }
    
    //MARK: TaskProgressInfoGetable
    func getProgressInfo() -> TaskProgressInfo {
        guard case let States.ended(datesStarted: started, dateEnded: ended) = state else { fatalError() }
        let taskProgressPeriod = TaskProgressPeriod.init(dateStarted: started, dateEnded: ended)
        return TaskProgressInfo.init(progressTimes: progressTimes, progressPeriod: taskProgressPeriod)
    }
}
