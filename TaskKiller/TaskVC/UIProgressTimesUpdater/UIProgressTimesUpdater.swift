//
//  ProgressTimeUpdater.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class UIProgressTimesUpdater: ProgressTimesCreating, ProgressTimesUpdatable {
    
    private let oneSecond: TimeInterval = 1
    
    private var initialProgressTimes: TaskProgressTimes!
    private weak var progressTimesReceiver: ProgressTimesReceiver!
    private var timer: Timer!
    
    private var initialTimeSpentInProgress: TimeInterval {
        return initialProgressTimes.timeSpentInprogress
    }
    private var initialTimeLeftToDeadLine: TimeLeftToDeadLine {
        return initialProgressTimes.timeLeftToDeadLine
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
    
    init(progressTimesReceiver: ProgressTimesReceiver) {
        self.progressTimesReceiver = progressTimesReceiver
    }
    
    //MARK: ProgressTimesUpdatable
    func updateProgressTimes(_ progressTimesSource: ProgressTimesCreating) {
        initialProgressTimes = progressTimesSource.createProgressTimes()
        progressTimesReceiver.receiveProgressTimes(progressTimesSource)
    }
    func startUpdatingUIProgressTimes(dateStarted: Date) {
        guard initialProgressTimes != nil else { fatalError() }
        dateProgressTimesUpdateStarted = dateStarted
        timer = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(reportOneSecondPassed), userInfo: nil, repeats: true)
    }
    func stopUpdatingUIProgressTimes() {
        timer.invalidate()
    }
    
    //MARK: TaskProgressTimesCreating
    func createProgressTimes() -> TaskProgressTimes {
        return currentPogressTimes
    }
   
    @objc private func reportOneSecondPassed() {
        progressTimesReceiver.receiveProgressTimes(self)
    }
}

