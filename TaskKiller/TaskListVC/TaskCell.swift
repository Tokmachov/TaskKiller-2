//
//  TaskCell.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell, TaskStaticInfoSetable, TaskProgressTimesSetable {

    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeToNextDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    let timeIntervalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    func setTaskStaticInfo(staticInfo: TaskStaticInfo) {
        let taskDesription = staticInfo.taskDescription
        let initialDeadLine = staticInfo.initialDeadLine
        let tagsInfoList = staticInfo.tags
        let tagsNamesString = tagsInfoList.getStringOfAllTagNames()
        taskDescriptionLabel.text = taskDesription
        initialDeadLineLabel.text = timeIntervalFormatter.format(initialDeadLine)
        tagsLabel.text = tagsNamesString
    }
    
    func setProgressTime(_ progresstime: TaskProgressTimes) {
        let timeSpentInprogress = progresstime.timeSpentInprogress
        let timeLeftToCurrentDeadLine = progresstime.timeLeftToCurrentDeadLine
        timeSpentInProgressLabel.setText(timeIntervalFormatter.format(timeSpentInprogress))
        timeToNextDeadLineLabel.setText(timeIntervalFormatter.format(timeLeftToCurrentDeadLine))
    }
}







