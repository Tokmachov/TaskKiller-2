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
    
    init(fireTime: TimeInterval) {
        self.fireTime = fireTime
    }
  
    mutating func postponeCurrentDeadLine(for time: TimeInterval) {
        fireTime += time
    }
  
    mutating func updateCurrentTime(_ time: TimeInterval, fireAction: () -> ()) {
        currentTime = time
        if fireTime <= time { fireAction() }
    }
}
