//
//  TaskCell.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell, TaskStaticInfoUpdatable, ProgressTimesUpdatable {
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeLeftToDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    func updateStaticInfo(_ staticInfoSource: TaskStaticInfoSource) {
        let taskDesription = staticInfoSource.staticInfo.taskDescription
        let initialDeadLine = formatter.string(from: staticInfoSource.staticInfo.initialDeadLine)
        taskDescriptionLabel.text = taskDesription
        initialDeadLineLabel.text = initialDeadLine
    }
    func updateProgressTimes(_ progressTimesSource: ProgressTimesSource) {
        let timeSpentInProgress = formatter.string(from: progressTimesSource.progressTimes.timeSpentInprogress)
        let timeLeftToDeadline: String = {
            switch progressTimesSource.progressTimes.timeLeftToDeadLine {
            case .noTimeLeft: return formatter.string(from: 0)!
            case .timeLeft(let time): return formatter.string(from: time)!
            }
        }()
        timeLeftToDeadLineLabel.text = timeSpentInProgress
        timeSpentInProgressLabel.text = timeLeftToDeadline
    }
}







