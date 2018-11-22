//
//  TaskState.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskState: ITaskState {
    
    private weak var stateChangesReceiver: TaskStateChangesReceiving!
    private var timeSpentInProgress: TimeInterval!
    private var postponableDeadLine: TimeInterval!
    private var progressTimes: TaskProgressTimes! {
        set {
            timeSpentInProgress = newValue.timeSpentInprogress
            postponableDeadLine = newValue.currentDeadLine
        }
        get {
            return TaskProgressTimes.init(timeSpentInprogress: timeSpentInProgress, currentDeadLine: postponableDeadLine)
        }
    }
    private var state: States! {
        didSet {
            switch state! {
            case .started:
                stateChangesReceiver.taskStateDidChangedToStarted()
            case .stopped:
                stateChangesReceiver.taskStateDidChangedToStopped(self)
            case .hasNotStarted: break
            }
        }
    }
   
    //MARK: TaskStatable
    init(stateChangesReceiver: TaskStateChangesReceiving) {
        self.stateChangesReceiver = stateChangesReceiver
    }
   
    mutating func changeState() {
        switch state! {
        case .hasNotStarted:
            let currentDate = Date()
            state = .started(datesStarted: currentDate)
        case .started(datesStarted: let date):
            let currentDate = Date()
            state = .stopped(dateStarted: date, dateStopped: currentDate)
        case .stopped(dateStarted: _, dateStopped: _):
            let currentDate = Date()
            state = .started(datesStarted: currentDate)
        }
    }
    mutating func prepareToStartTaskStateTracking(withInitialInfoFrom taskProgressTimesSource: TaskProgressTimesGetable) {
        self.progressTimes = taskProgressTimesSource.getProgressTimes()
        self.state = States.hasNotStarted
    }
    
    mutating func prapareToStopTaskStateTracking() {
        switch state! {
        case .hasNotStarted:
            break
        case .started(datesStarted: let date):
            let currentDate = Date()
            state = States.stopped(dateStarted: date, dateStopped: currentDate)
        case .stopped:
            break
        }
    }
    
    mutating func incrementTimeSpentInProgress(by timeIncrement: TimeInterval) {
        self.timeSpentInProgress += timeIncrement
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
        guard case let States.stopped(dateStarted: started, dateStopped: ended) = state! else { fatalError() }
        let taskProgressPeriod = TaskProgressPeriod.init(dateStarted: started, dateEnded: ended)
        return TaskProgressInfo.init(progressTimes: progressTimes, progressPeriod: taskProgressPeriod)
    }
}
