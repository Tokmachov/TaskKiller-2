//
//  CurrentTimeSpentInProgressreceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 16.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol CurrentTimeSpentInProgressReceiving: AnyObject {
    func receiveCurrentTimeSpentInProgress(_ time: TimeInterval)
}
