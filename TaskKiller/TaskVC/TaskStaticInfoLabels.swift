//
//  TaskStaticInfoDisplayingUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskStaticInfoLabels: TaskStaticInfoSetable {

    let taskDescriptionLabel: UILabel
    let initialDeadLineLabel: UILabel
    let tagsLabel: UILabel
    
    let timeIntrvalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    init(forDescription: UILabel, forInitialDeadLine: UILabel, forTags: UILabel) {
        self.taskDescriptionLabel = forDescription
        self.initialDeadLineLabel = forInitialDeadLine
        self.tagsLabel = forTags
    }
    
    func setTaskStaticInfo(staticInfo: TaskStaticInfo) {
        let taskDescription = staticInfo.taskDescription
        let initialDeadLine = staticInfo.initialDeadLine
        let tagsNames = staticInfo.tagsInfos
        
        let stringInitialDeadline = timeIntrvalFormatter.format(initialDeadLine)
        let stringTagsNamses = tagsNames.getStringOfAllTagNames()
        
        taskDescriptionLabel.setText(taskDescription)
        initialDeadLineLabel.setText(stringInitialDeadline)
        tagsLabel.setText(stringTagsNamses)
    }
}
 

