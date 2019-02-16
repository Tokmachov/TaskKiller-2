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
    private lazy var progressTimesLabelsController = ProgressTimesLabelsController(
        timeSpentInProgressLabel: timeSpentInProgressLabel,
        timeLeftToDeadLineLabel: timeLeftToDeadLineLabel
    )
    let timeIntervalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    func updateStaticInfo(_ staticInfoSource: TaskStaticInfoCreating) {
        let staticInfo = staticInfoSource.createStaticInfo()
        let taskDesription = staticInfo.taskDescription
        let initialDeadLine = staticInfo.initialDeadLine
        taskDescriptionLabel.text = taskDesription
        initialDeadLineLabel.text = timeIntervalFormatter.format(initialDeadLine)
    }
    func updateProgressTimes(_ progressTimesSource: ProgressTimesCreating) {
        progressTimesLabelsController.updateProgressTimes(progressTimesSource)
    }
}







