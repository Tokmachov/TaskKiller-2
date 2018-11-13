//
//  TaskStaticInfoDisplayingUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskStaticInfoDisplayingUIComponents: TaskStaticInfoSetable {

    let taskDescriptionLabel: UILabel
    let initialDeadLineLabel: UILabel
    let tagsLabel: UILabel
    
    let timeIntrvalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    init(taskDescriptionLabel: UILabel, initialDeadLineLabel: UILabel, tagsLabel: UILabel) {
        self.taskDescriptionLabel = taskDescriptionLabel
        self.initialDeadLineLabel = initialDeadLineLabel
        self.tagsLabel = tagsLabel
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
 
