//
//  Alarming.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 15.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation


protocol Alarming {
    init(alarmReceiver: Alarmable)
    func updateCurrentTime(_ timeInteral: TimeInterval)
    func setTimeWhenFires(_ timeInterval: TimeInterval)
}
