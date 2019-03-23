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
    
    
    let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    init(forDescription: UILabel, forInitialDeadLine: UILabel) {
        self.taskDescriptionLabel = forDescription
        self.initialDeadLineLabel = forInitialDeadLine
    }
    func updateStaticInfo(_ staticInfoSource: TaskStaticInfoSource) {
        taskDescriptionLabel.text = staticInfoSource.staticInfo.taskDescription
        initialDeadLineLabel.text = formatter.string(from: staticInfoSource.staticInfo.initialDeadLine)
    }
}
 

