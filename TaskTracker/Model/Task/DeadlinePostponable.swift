//
//  DeadlinePostponable.swift
//  TaskKiller
//
//  Created by mac on 20/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol DeadlinePostponable {
    func postponeDeadlineFor(_ timeInterval: TimeInterval)
}