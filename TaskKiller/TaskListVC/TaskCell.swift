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
        print(staticInfo)
        let taskDesription = staticInfo.taskDescription
        let initialDeadLine = staticInfo.initialDeadLine
        let tagsInfoList = staticInfo.tagsInfos
        let tagsNamesString = tagsInfoList.getStringOfAllTagNames()
        taskDescriptionLabel.text = taskDesription
        initialDeadLineLabel.text = timeIntervalFormatter.format(initialDeadLine)
        tagsLabel.text = tagsNamesString
    }
    
    func setProgressTime(_ progresstime: TaskProgressTimes) {
        print(progresstime)
        let timeSpentInprogress = progresstime.timeSpentInprogress
        let currentDeadLine = progresstime.currentDeadLine
        let timeLeftToCurrentDeadLine = currentDeadLine - timeSpentInprogress
        timeSpentInProgressLabel.text = timeIntervalFormatter.format(timeSpentInprogress)
        timeToNextDeadLineLabel.text = timeIntervalFormatter.format(timeLeftToCurrentDeadLine)
    }
}







