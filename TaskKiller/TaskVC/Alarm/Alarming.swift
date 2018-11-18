//
//  Alarming.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 15.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation


protocol Alarming {
    
    init(fireTime: TimeInterval)
    mutating func updateCurrentTime(_ time: TimeInterval, fireAction: ()->())
    mutating func setTimeWhenFires(_ time: TimeInterval)
}
