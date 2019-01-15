//
//  ProgressTimeUpdating.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskProgressTimesUpdating {
    func update(_ updatable: TaskProgressTimesSetable, from source: TaskProgressTimesGetable)
}
