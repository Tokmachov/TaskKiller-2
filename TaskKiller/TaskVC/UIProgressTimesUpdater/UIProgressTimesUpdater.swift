//
//  ProgressTimeUpdater.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class UIProgressTimesUpdater: TaskProgressTimesCreating {
    
    private let oneSecond: TimeInterval = 1
    
    private var initialTaskProgressTimes: TaskProgressTimes
    private weak var progressTimesReceiver: ProgressTimesReceiver!
    private var timer: Timer!
    
    private var initialTimeSpentInProgress: TimeInterval {
        return initialTaskProgressTimes.timeSpentInprogress
    }
    private var initialTimeLeftToDeadLine: TimeLeftToDeadLine {
        return initialTaskProgressTimes.timeLeftToDeadLine
    }
    
    private var dateProgressTimesUpdateStarted: Date?
    
    private var timePassedSinceUpdateStarted: TimeInterval {
        return dateProgressTimesUpdateStarted != nil ? Date().timeIntervalSince(dateProgressTimesUpdateStarted!) : 0
    }
    
    private var currentTimeSpentInProgress: TimeInterval {
        return timePassedSinceUpdateStarted + initialTimeSpentInProgress
    }
    private var currentTimeLeftToDeadLine: TimeLeftToDeadLine {
        let timeLeftToDeadline = initialTimeLeftToDeadLine.reduceBy(timePassedSinceUpdateStarted)
        return timeLeftToDeadline
    }
    private var currentPogressTimes: TaskProgressTimes {
        return TaskProgressTimes.init(timeSpentInprogress: currentTimeSpentInProgress, timeLeftToDeadLine: currentTimeLeftToDeadLine)
    }
    
    init(initialProgressTimesSource: TaskProgressTimesCreating, progressTimesReceiver: ProgressTimesReceiver) {
        self.initialTaskProgressTimes = initialProgressTimesSource.createProgressTimes()
        self.progressTimesReceiver = progressTimesReceiver
        progressTimesReceiver.receiveProgressTimes(self)
    }
    
    func startUpdatingUIProgressTimes(initialProgressTimesSource: TaskProgressTimesCreating) {
        dateProgressTimesUpdateStarted = Date()
        initialTaskProgressTimes = initialProgressTimesSource.createProgressTimes()
        timer = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(reportOneSecondPassed), userInfo: nil, repeats: true)
    }

    func stopUpdatingUIProgressTimes() {
        timer.invalidate()
    }
    func updateTimeLeftToDeadline(_ timeLeftToDeadlineSource: TimeLeftToDeadLineGetable) {
        initialTaskProgressTimes.timeLeftToDeadLine = timeLeftToDeadlineSource.timeLeftToDeadLine
    }
    
    //MARK: TaskProgressTimesCreating
    func createProgressTimes() -> TaskProgressTimes {
        return currentPogressTimes
    }
    
    @objc private func reportOneSecondPassed() {
        progressTimesReceiver.receiveProgressTimes(self)
    }
}

