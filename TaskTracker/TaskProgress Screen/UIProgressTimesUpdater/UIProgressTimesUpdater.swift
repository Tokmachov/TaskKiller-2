//
//  ProgressTimeUpdater.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class ProgressTimesUpdaterImp: ProgressTimesUpdater {
    
    private let oneSecond: TimeInterval = 1
    
    private var initialTimes: ProgressTimes!
    private var dateUpdateStarted: Date!
    
    private weak var delegate: UIProgressTimesUpdaterDelegate!
    private var timer: Timer!
    
    //MARK: ProgressTimesUpdater
    required init(delegate: UIProgressTimesUpdaterDelegate) {
        self.delegate = delegate
    }
    
    func startUpdatingUIProgressTimes(dateStarted: Date, initialTimes progressTimesSource: ProgressTimesSource) {
        dateUpdateStarted = dateStarted
        self.initialTimes = progressTimesSource.progressTimes
        timer = Timer.scheduledTimer(timeInterval: oneSecond, target: self, selector: #selector(reportOneSecondPassed), userInfo: nil, repeats: true)
    }
    func stopUpdatingUIProgressTimes() {
        timer.invalidate()
    }
    
    //MARK: ProgressTimesUpdatable
    func updateProgressTimes(from progressTimesSource: ProgressTimesSource) {
        initialTimes = progressTimesSource.progressTimes
        delegate.uIPrgressTimesUpdaterDidUpdateProgressTimes(self)
    }
    
    //MARK: TaskProgressTimesSource
    var progressTimes: ProgressTimes {
        let initialTimeSpent = initialTimes.timeSpentInprogress
        let initialTimeLeft = initialTimes.timeLeftToDeadLine
        let timeSpentSinceUpdateStarted = dateUpdateStarted != nil ? Date().timeIntervalSince(dateUpdateStarted!) : 0
        let currentTimeSpent = initialTimeSpent + timeSpentSinceUpdateStarted
        let currentTimeLeft = initialTimeLeft.reduceBy(timeSpentSinceUpdateStarted)
        return ProgressTimes(timeSpentInprogress: currentTimeSpent, timeLeftToDeadLine: currentTimeLeft)
    }
   
    @objc private func reportOneSecondPassed() {
        delegate.uIPrgressTimesUpdaterDidUpdateProgressTimes(self)
    }
}

