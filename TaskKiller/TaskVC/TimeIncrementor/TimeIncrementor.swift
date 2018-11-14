//
//  TimeIncrementor.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TimeIncrementor: TimeIncrementing {
    let oneSecond: TimeInterval = 1
    private var timer: Timer!
    private let timeIncrementsReceiver: TimeIncrementsReceiving
    
    init(timeIncrementsReceiver: TimeIncrementsReceiving) {
        self.timeIncrementsReceiver = timeIncrementsReceiver
    }
    
    mutating func start() {
        timer = Timer.scheduledTimer(withTimeInterval: oneSecond, repeats: true, block: { [weak timeIncrementsReceiver] (timer) in
            let oneSecondTimeIncrement: TimeInterval = 1
            timeIncrementsReceiver?.receiveTimeIncrement(oneSecondTimeIncrement) })
    }
    
    func stop() {
        timer.invalidate()
    }
}
