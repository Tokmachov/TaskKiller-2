//
//  TaskStateable.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStatable {
    
    init(stateChangesReceiver: TaskStateChangesReceiving)
    
    mutating func changeState()
    mutating func prepareToStartTaskStateTracking(withInitialInfoFrom taskProgressTimesSource: TaskProgressTimesGetable)
    mutating func prapareToStopTaskStateTracking()
    mutating func incrementTimeSpentInProgress(by timeIncrement: TimeInterval)
    mutating func postponeCurrentDeadline(for additionalTime: TimeInterval)
   
}
