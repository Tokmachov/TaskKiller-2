//
//  ProgressTimesUpdater.swift
//  TaskTracker
//
//  Created by mac on 07/05/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol ProgressTimesUpdater: ProgressTimesSource, ProgressTimesUpdatable {
    init(delegate: UIProgressTimesUpdaterDelegate)
    func startUpdatingUIProgressTimes(dateStarted: Date, initialTimes progressTimesSource: ProgressTimesSource)
    func stopUpdatingUIProgressTimes()
}
