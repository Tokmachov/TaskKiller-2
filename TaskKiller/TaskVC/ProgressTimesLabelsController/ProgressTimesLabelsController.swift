//
//  ProgressTimesLabels.swift
//  TaskKiller
//
//  Created by mac on 28/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct ProgressTimesLabelsController {
    private var timeSpentInProgressLabel: UILabel
    private var timeLeftToDeadlineLabel: UILabel
    private var timeIntervalForatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    init(timeSpentInProgressLabel: UILabel, timeLeftToDeadLineLabel: UILabel) {
        self.timeSpentInProgressLabel = timeSpentInProgressLabel
        self.timeLeftToDeadlineLabel = timeLeftToDeadLineLabel
    }
}

extension ProgressTimesLabelsController: ProgressTimesUpdatable {
 
    func updateProgressTimes(_ progressTimesSource: ProgressTimesSource) {
        let progressTimes = progressTimesSource.createProgressTimes()
        let timeSpentInProgress = progressTimes.timeSpentInprogress
        let timeLeftToDeadLine = extractTimeLeftToDeadLineTimeIntervalValueFrom(progressTimes)
        timeSpentInProgressLabel.setText(timeIntervalForatter.format(timeSpentInProgress))
        timeLeftToDeadlineLabel.setText(timeIntervalForatter.format(timeLeftToDeadLine))
    }
    private func extractTimeLeftToDeadLineTimeIntervalValueFrom(_ progressTimes: TaskProgressTimes) -> TimeInterval {
        var timeLeftToDeadLine: TimeInterval
        switch progressTimes.timeLeftToDeadLine {
        case .noTimeLeft: timeLeftToDeadLine = 0
        case .timeLeft(let time): timeLeftToDeadLine = time
        }
        return timeLeftToDeadLine
    }
}
