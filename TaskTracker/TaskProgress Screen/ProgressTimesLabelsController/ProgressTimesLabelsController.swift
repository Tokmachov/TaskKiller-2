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
    private let formatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .hour, .second]
            formatter.unitsStyle = .positional
            return formatter
    }()
    
    init(timeSpentInProgressLabel: UILabel, timeLeftToDeadLineLabel: UILabel) {
        self.timeSpentInProgressLabel = timeSpentInProgressLabel
        self.timeLeftToDeadlineLabel = timeLeftToDeadLineLabel
        setupLabels()
    }
}

extension ProgressTimesLabelsController: ProgressTimesUpdatable {
 
    func updateProgressTimes(from progressTimesSource: ProgressTimesSource) {
        timeSpentInProgressLabel.text = formatter.string(from: progressTimesSource.progressTimes.timeSpentInprogress)
        timeLeftToDeadlineLabel.text = {
            switch progressTimesSource.progressTimes.timeLeftToDeadLine {
            case .noTimeLeft: return formatter.string(from: 0)
            case .timeLeft(let time): return formatter.string(from: time)
            }
        }()
    }
}

extension ProgressTimesLabelsController {
    private func setupLabels() {
       setupTimeLeftToDeadlineLabel()
       setupTimeSpentInProgressLabel()
    }
    private func setupTimeLeftToDeadlineLabel() {
        let font = timeLeftToDeadlineLabel.font
        timeLeftToDeadlineLabel.font = UIFontMetrics.default.scaledFont(for: font!)
        timeSpentInProgressLabel.adjustsFontForContentSizeCategory = true
    }
    private func setupTimeSpentInProgressLabel() {
        let font = timeSpentInProgressLabel.font
        timeSpentInProgressLabel.font = UIFontMetrics.default.scaledFont(for: font!)
        timeSpentInProgressLabel.adjustsFontForContentSizeCategory = true
    }
}
