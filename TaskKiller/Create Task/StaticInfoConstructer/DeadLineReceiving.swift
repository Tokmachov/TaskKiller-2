//
//  DeadLineReceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol DeadLineReceiving {
    func receiveDeadLine(_ deadLine: TimeInterval)
}
