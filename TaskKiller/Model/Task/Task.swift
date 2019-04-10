//
//  TaskModelHandling.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import CoreData

protocol Task: DeadlinePostponable {
    var tagsStore: ImmutableTagStore { get }
    func getTaskDescription() -> String
    
    func getTimeSpentInProgress() -> TimeInterval
    
    func getInitialDeadline() -> TimeInterval
    
    func getCurrentDeadline() -> TimeInterval
    
    func saveProgressPeriod(_ period: ProgressPeriod)
    
    func addTags(_ tags: ImmutableTagStore)
}




