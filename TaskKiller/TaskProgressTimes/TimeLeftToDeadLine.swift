//
//  TimeLeftToDeadLine.swift
//  TaskKiller
//
//  Created by mac on 25/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

enum TimeLeftToDeadLine {
    case timeLeft(TimeInterval)
    case noTimeLeft
    init(timeLeftToDeadLine: TimeInterval) {
        switch timeLeftToDeadLine {
        case let time where time > 0: self = .timeLeft(timeLeftToDeadLine)
        default: self = .noTimeLeft
        }
    }
}
extension TimeLeftToDeadLine {
    func reduceBy(_ timeInterval: TimeInterval) -> TimeLeftToDeadLine {
        switch self {
        case .noTimeLeft: return .noTimeLeft
        case .timeLeft(let time) where time > timeInterval : return .timeLeft(time - timeInterval)
        case .timeLeft(let time) where time <= timeInterval: return .noTimeLeft
        default: return .noTimeLeft
        }
    }
    func increaseBy(_ timeInterval: TimeInterval) -> TimeLeftToDeadLine {
        switch self {
        case .noTimeLeft: return .timeLeft(timeInterval)
        case .timeLeft(let time): return .timeLeft(timeInterval + time)
        }
    }
    var timeLeft: TimeInterval? {
        guard case let .timeLeft(time) = self else { return nil }
        return time
    }
}
