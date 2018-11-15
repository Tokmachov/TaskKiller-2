//
//  AlarmClock.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 15.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct AlarmClock: Alarming {
    
    private weak var alarmReceiver: Alarmable
    private var currentTime: TimeInterval {
        didSet {
            if currentTime = timeWhenFires { alarmReceiver.alarmDidFire() }
        }
    }
    private var timeWhenFires: TimeInterval
    init(alarmReceiver: Alarmable) {
        self.alarmReceiver = alarmReceiver
    }
    
    func updateCurrentTime(_ time: TimeInterval) {
        currentTime = time
    }
    
    func setTimeWhenFires(_ time: TimeInterval) {
        timeWhenFires = time
    }
}
