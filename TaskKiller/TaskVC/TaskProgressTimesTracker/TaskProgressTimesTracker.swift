//
//  ProgressTimeUpdater.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskProgressTimesTracker: TaskProgressTimesUpdatable, TaskProgressTimesCreating {
    
    private let oneSecond: TimeInterval = 1
    private var timeLeftToDeadLine: TimeLeftToDeadLine
    private var timeSpentInProgress: TimeInterval
    private weak var progressTimesReceiver: ProgressTimesReceiver!
    private var timer: Timer!
    
    init(initialProgressTimesSource: TaskProgressTimesCreating, progressTimesReceiver: ProgressTimesReceiver) {
        let progressTimes = initialProgressTimesSource.createProgressTimes()
        self.timeLeftToDeadLine = progressTimes.timeLeftToDeadLine
        self.timeSpentInProgress = progressTimes.timeSpentInprogress
        self.progressTimesReceiver = progressTimesReceiver
        sentToPogressTimesReceiverInitialProgressTimes()
    }
    
    func startTrackingProgressTimes() {
        timer = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(reportOneSecondPassed), userInfo: nil, repeats: true)
    }
    
    func stopTrackingProgressTimes() {
        timer.invalidate()
    }
    //MARK: ProgressTimesUpdatable
    func updateProgressTimes(_ progressTimesSource: TaskProgressTimesCreating) {
        let progressTimes = progressTimesSource.createProgressTimes()
        self.timeSpentInProgress = progressTimes.timeSpentInprogress
        self.timeLeftToDeadLine = progressTimes.timeLeftToDeadLine
    }
    //MARK: ProgressTimesCreating
    func createProgressTimes() -> TaskProgressTimes {
        let progressTimes = TaskProgressTimes.init(
            timeSpentInprogress: timeSpentInProgress,
            timeLeftToDeadLine: timeLeftToDeadLine
        )
        return progressTimes
    }
    
    @objc private func reportOneSecondPassed() {
        incrementTimeSpentInProgress()
        decrementTimeLeftToDeadLine()
        reportTrackedProgressTimes()
    }
    
    private func incrementTimeSpentInProgress() {
        timeSpentInProgress += 1
    }
    
    private func decrementTimeLeftToDeadLine() {
        switch timeLeftToDeadLine {
        case .noTimeLeft: break
        case .timeLeft(let time) where time > 0: timeLeftToDeadLine = .timeLeft(time - 1)
        case .timeLeft(let time) where time == 0: timeLeftToDeadLine = .noTimeLeft
        default: break
        }
    }
    
    private func reportTrackedProgressTimes() {
        progressTimesReceiver.receiveProgressTimes(self)
    }
    
    private func sentToPogressTimesReceiverInitialProgressTimes() {
        progressTimesReceiver.receiveProgressTimes(self)
    }
}

