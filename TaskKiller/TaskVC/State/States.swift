//
//  States.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 14.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

enum States {
    case hasNotStarted
    case started(datesStarted: Date)
    case ended(datesStarted: Date, dateEnded: Date)
}
