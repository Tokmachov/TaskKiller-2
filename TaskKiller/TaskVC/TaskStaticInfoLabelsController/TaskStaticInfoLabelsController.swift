//
//  TaskStaticInfoDisplayingUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskStaticInfoLabelsController: TaskStaticInfoUpdatable {

    let taskDescriptionLabel: UILabel
    let initialDeadLineLabel: UILabel
    
    
    let timeIntrvalFormatter: TimeIntervalFormatting = TimeIntervalFormatter()
    
    init(forDescription: UILabel, forInitialDeadLine: UILabel) {
        self.taskDescriptionLabel = forDescription
        self.initialDeadLineLabel = forInitialDeadLine
    }
    func updateStaticInfo(_ staticInfoSource: TaskStaticInfoCreating) {
        let staticInfo = staticInfoSource.createStaticInfo()
        let taskDescription = staticInfo.taskDescription
        let initialDeadLine = staticInfo.initialDeadLine
        
        let stringInitialDeadline = timeIntrvalFormatter.format(initialDeadLine)
        
        taskDescriptionLabel.setText(taskDescription)
        initialDeadLineLabel.setText(stringInitialDeadline)
    }
}
 

