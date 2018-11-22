//
//  AlarmClock.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 15.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct AlarmClock: Alarming {
    
    private var fireTime: TimeInterval!
    private var currentTime: TimeInterval!
    private weak var alarmReceiver: AlarmReceiving!
    
    //MARK: Alarming
    init(alarmReceiver: AlarmReceiving) {
        self.alarmReceiver = alarmReceiver
    }
    
    mutating func setAlarmClockCurrentAndFireTimes(from progressTimesSource: TaskProgressTimesGetable) {
        let progressTimes = progressTimesSource.getProgressTimes()
        let currentTime = progressTimes.timeSpentInprogress
        let fireTime = progressTimes.currentDeadLine
        self.fireTime = fireTime
        self.currentTime = currentTime
    }

    mutating func incrementCurrentTime(_ timeIncrement: TimeInterval) {
        self.currentTime += timeIncrement
        if fireTime <= currentTime { alarmReceiver.alarmDidFire() }
    }
    mutating func postponeFireTime(for time: TimeInterval) {
        fireTime += time
    }
}
