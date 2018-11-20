//
//  TimeIncrementor.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

class TimeCounter: TimeCounting {
   
    let oneSecondTimeInterval: TimeInterval = 1
    private var timer: Timer!
    private var timeSpentInProgress: TimeInterval
    private weak var timeSpentInprogressReceiver: TimeSpentInProgressReceiving!
    
    required init(initialTime: TimeInterval, timeUpdatesReceiver: TimeSpentInProgressReceiving) {
        self.timeSpentInProgress = initialTime
        self.timeSpentInprogressReceiver = timeUpdatesReceiver
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: oneSecondTimeInterval, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { fatalError() }
            self.timeSpentInProgress += self.oneSecondTimeInterval
            self.timeSpentInprogressReceiver.receiveTime(self.timeSpentInProgress)
        })
    }
    
    func stop() {
        timer.invalidate()
    }
}
