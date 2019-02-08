//
//  States.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

enum States {
    case notStarted
    case started(date: Date)
    case stopped(started: Date, ended: Date)
}
