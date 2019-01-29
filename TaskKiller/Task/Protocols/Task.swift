//
//  TaskModelHandling.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

protocol Task {
    init(task: TaskModel)
    
    func getTaskDescription() -> String
    
    func getTimeSpentInProgress() -> TimeInterval
    
    func getDeadLine() -> TimeInterval
    
    func saveTaskProgressPeriod(_ period: TaskProgressPeriod)
    
    func addTags(_ tags: AllTagsGetableStore)
}
