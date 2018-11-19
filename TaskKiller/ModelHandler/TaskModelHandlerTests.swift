//
//  TaskModelHandlerTests.swift
//  TaskKillerTests
//
//  Created by Oleg Tokmachov on 19.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import XCTest
import CoreData
@testable import TaskKiller

class TaskModelHandlerTests: XCTestCase {
    
    func test() {
        let task = fetchTask()
        let deadLine = task.postponableDeadLine
        let timeSpentInProgress = task.timeSpentInProgress
        let taskGoal = task.taskDescription
        print("dead line \(deadLine), timeSpentInProgress \(timeSpentInProgress) taskGoal \(taskGoal)")
    }
    
    private func fetchTask() -> Task {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        let a = try? fetchRequest.execute()
        let task = a?.first
        return task!
    }
    
}
