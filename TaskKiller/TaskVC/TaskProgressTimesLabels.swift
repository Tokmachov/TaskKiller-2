//
//  TimeChangesDisplayingUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 16.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskProgressTimesLabels: TaskProgressTimesSetable {
    
    private weak var timeSpentInprogressLabel: UILabel!
    private weak var timeLeftToNextDeadLineLabel: UILabel!
    private let timeIntervalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    init(forTimeSpentInProgress timeSpentInProgressLabel: UILabel, forTimeLeft timeLeftLabel: UILabel) {
        self.timeSpentInprogressLabel = timeSpentInProgressLabel
        self.timeLeftToNextDeadLineLabel = timeLeftLabel
    }
    
    //MARK: TaskProgressTimesSetable
    func setProgressTime(_ progresstime: TaskProgressTimes) {
        let timeSpentInProgress = progresstime.timeSpentInprogress
        let timeLeftToNextDeadline = progresstime.timeLeftToCurrentDeadLine
        
        let timeSpentInProgressFormatted = timeIntervalFormatter.format(timeSpentInProgress)
        let timeLeftToCurrentDeadLineFormatted = timeIntervalFormatter.format(timeLeftToNextDeadline)
        
        timeSpentInprogressLabel.setText(timeSpentInProgressFormatted)
        timeLeftToNextDeadLineLabel.setText(timeLeftToCurrentDeadLineFormatted)
    }
}
