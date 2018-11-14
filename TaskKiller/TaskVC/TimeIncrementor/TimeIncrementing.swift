//
//  TimeCounting.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TimeIncrementing {    
    init(timeIncrementsReceiver: TimeIncrementsReceiving)
    mutating func start()
    func stop()
}
