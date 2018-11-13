//
//  TaskModelHandling.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

protocol ITaskModelFacade {
    init(task: Task)
    
    func getTaskDescription() -> String
   
    func getDeadLine() -> TimeInterval
    
    func getPostponableDeadLine() -> TimeInterval
    
    func getTimeSpentInProgress() -> TimeInterval
    
    func getTagsInfosList() -> TagsInfosList
}
