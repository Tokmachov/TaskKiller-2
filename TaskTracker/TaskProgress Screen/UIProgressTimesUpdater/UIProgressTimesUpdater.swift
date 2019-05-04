//
//  ProgressTimeUpdater.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class UIProgressTimesUpdater: ProgressTimesSource, ProgressTimesUpdatable {
    
    private let oneSecond: TimeInterval = 1
    
    private var initialProgressTimes: TaskProgressTimes!
    private weak var delegate: UIProgressTimesUpdaterDelegate!
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
    
    init(delegate: UIProgressTimesUpdaterDelegate) {
        self.delegate = delegate
    }
    
    //MARK: ProgressTimesUpdatable
    func updateProgressTimes(from progressTimesSource: ProgressTimesSource) {
        initialProgressTimes = progressTimesSource.progressTimes
        delegate.uIPrgressTimesUpdaterDidUpdateProgressTimes(self)
    }
    func startUpdatingUIProgressTimes(dateStarted: Date) {
        guard initialProgressTimes != nil else { fatalError() }
        dateProgressTimesUpdateStarted = dateStarted
        timer = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(reportOneSecondPassed), userInfo: nil, repeats: true)
    }
    func stopUpdatingUIProgressTimes() {
        timer.invalidate()
    }
    
    //MARK: TaskProgressTimesSource
    var progressTimes: TaskProgressTimes {
        return currentPogressTimes
    }
   
    @objc private func reportOneSecondPassed() {
        delegate.uIPrgressTimesUpdaterDidUpdateProgressTimes(self)
    }
}

