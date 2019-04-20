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
    var id: String { get }
    var description: String { get }
    var timeSpentInProgress: TimeInterval { get }
    var initialDeadline: TimeInterval { get }
    var currentDeadline: TimeInterval { get }
    var tagsStore: ImmutableTagStore { get }
    
    func saveProgressPeriod(_ period: ProgressPeriod)
    func addTags(_ tags: ImmutableTagStore)
}
