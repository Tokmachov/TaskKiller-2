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
    private weak var postponableDeadLineChangesReceiver: PostponableDeadlineChangesReceiving!
    private weak var currentTimeSpentInProgressReceiving: CurrentTimeSpentInProgressReceiving!
    
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
    init(taskProgressTimes: TaskProgressTimes, postponableDeadLineChangesReceiver: PostponableDeadlineChangesReceiving, currentTimeSpentInProgressReceiver currentTimeSpentInProgressReceiving: CurrentTimeSpentInProgressReceiving) {
        self.timeSpentInProgress = taskProgressTimes.timeSpentInprogress
        self.postponableDeadLine = taskProgressTimes.currentDeadLine
        self.postponableDeadLineChangesReceiver = postponableDeadLineChangesReceiver
        self.currentTimeSpentInProgressReceiving = currentTimeSpentInProgressReceiving
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
    
    mutating func incrementTimeSpentInProcess(by increment: TimeInterval) {
        self.timeSpentInProgress += increment
        self.currentTimeSpentInProgressReceiving.receiveCurrentTimeSpentInProgress(timeSpentInProgress)
    }
    
    mutating func setPostponableDeadLine(_ deadLine: TimeInterval) {
        self.postponableDeadLine = deadLine
        self.postponableDeadLineChangesReceiver.postponableDeadLineDidchanged(deadLine)
    }
    
    func getCurrentTimeSpentInProgress() -> TimeInterval {
        return timeSpentInProgress
    }
    
    //MARK: TaskProgressTimesGetable
    func getProgressTimes() -> TaskProgressTimes {
        return progressTimes
    }
}