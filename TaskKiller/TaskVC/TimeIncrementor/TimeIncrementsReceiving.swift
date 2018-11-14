//
//  TimeIncrementsReceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TimeIncrementsReceiving: AnyObject {
    func receiveTimeIncrement(_ incrementValue: TimeInterval)
}
