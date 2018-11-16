//
//  TimeChangesDisplayingUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 16.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TimeChangesDiplayingUIComponents: TaskProgressTimesSetable {
    
    
    
    private weak var timeSpentInprogressDisplay: UILabel!
    private weak var timeLeftToNextDeadLineDisplay: UILabel!
    private let timeIntervalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    init(timeSpentInprogressDisplay: UILabel, timeLeftToNextDeadLineDisplay: UILabel) {
        self.timeSpentInprogressDisplay = timeSpentInprogressDisplay
        self.timeLeftToNextDeadLineDisplay = timeLeftToNextDeadLineDisplay
    }
    
    //MARK: TaskProgressTimesSetable
    func setProgressTime(_ progresstime: TaskProgressTimes) {
        let timeSpentInProgress = progresstime.timeSpentInprogress
        let timeLeftToNextDeadline = progresstime.timeLeftToCurrentDeadLine
        
        let timeSpentInProgressFormatted = timeIntervalFormatter.format(timeSpentInProgress)
        let timeLeftToCurrentDeadLineFormatted = timeIntervalFormatter.format(timeLeftToNextDeadline)
        
        timeSpentInprogressDisplay.setText(timeSpentInProgressFormatted)
        timeLeftToNextDeadLineDisplay.setText(timeLeftToCurrentDeadLineFormatted)
    }
}
