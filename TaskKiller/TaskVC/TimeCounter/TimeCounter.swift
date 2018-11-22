//
//  TimeIncrementor.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TimeCounter: TimeCounting {
   
    let oneSecondTimeInterval: TimeInterval = 1
    private var timer: Timer!
    private weak var timeSpentInprogressReceiver: TimeIncrementsReceiving!
    
    init(timeUpdatesReceiver: TimeIncrementsReceiving) {
        self.timeSpentInprogressReceiver = timeUpdatesReceiver
    }
    
    mutating func start() {
        timer = Timer.scheduledTimer(withTimeInterval: oneSecondTimeInterval, repeats: true, block: { [ weak timeSpentInprogressReceiver ] (timer) in
            let oneSecondTimeInterval = TimeInterval(1)
            guard timeSpentInprogressReceiver != nil else { fatalError() }
            timeSpentInprogressReceiver!.receiveTimeIncrement(oneSecondTimeInterval)
        })
    }
    
    func stop() {
        timer.invalidate()
    }
}
