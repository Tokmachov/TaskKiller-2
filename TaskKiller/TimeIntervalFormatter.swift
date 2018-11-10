//
//  TimeIntervalFormatter.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TimeIntervalFormatter: TimeIntervalFormatting {
    let secondsInMinute = 60
    let secondsInHour = 3600
    let secondsIn24Hours = 84_400

    func format(_ time: TimeInterval) -> String {
        let seconds = Int(time) % secondsInMinute                       // 0 <= seconds <= 60
        let minutes = (Int(time) % secondsInHour) / secondsInMinute     // 0 <= minuts <= 60
        let hours = (Int(time) % secondsIn24Hours) / secondsInHour      // 0 <= houres <= 24
        let days = Int(time) / secondsIn24Hours                         // 0 <= days <= infinity
        guard days == 0 else { return "error" }
        return "\(hours) : \(minutes) : \(seconds)"
    }
}
