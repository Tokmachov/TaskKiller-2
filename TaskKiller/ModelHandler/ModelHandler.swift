//
//  ModelHandler.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

struct ModelHandler: ModelInitiatable {
    
    private var task: Task?
    
    init(taskStaticInfoSource: StaticInfoGetable) {
        self.task = nil
        self.task = createModel(taskStaticInfoSource: taskStaticInfoSource)
    }
    private func createModel(taskStaticInfoSource: StaticInfoGetable) -> Task {
        
        let taskStaticInfo = taskStaticInfoSource.getStaticInfo()
        
        let taskDescription = taskStaticInfo.taskDescription
        let initiaLdeadLine = taskStaticInfo.initialDeadLine
        let postponableDeadline = taskStaticInfo.initialDeadLine
        let tags = taskStaticInfo.tags
        
        let task = Task(context: <#T##NSManagedObjectContext#>)
    }
}
