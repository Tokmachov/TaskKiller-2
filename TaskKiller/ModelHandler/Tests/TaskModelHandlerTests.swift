//
//  TaskModelHandlerTests.swift
//  TaskKillerTests
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import XCTest
@testable import TaskKiller
import CoreData

class TaskModelHandlerTests: XCTestCase {
    
    var taskModelCreator: TaskModelCreatingModelHandler = TaskModelCreator()
    var taskProgressTracker: TaskProgressTrackingModelHandler!
    let taskDescription = "SomeDescription"
    let taskInitialDeadline = TimeInterval(20)
    let tagInfo = TagInfo(projectName: "SomeTag")
    var tagsInfosList: TagsInfosList {
        var tagsInfosList = TagsInfosList()
        tagsInfosList.addTagInfo(tagInfo)
        return tagsInfosList
    }
    var taskStaticIfo: TaskStaticInfo {
        return TaskStaticInfo.init(taskDescription: taskDescription, initialDeadLine: taskInitialDeadline, tagsInfos: tagsInfosList)
    }
    
    func testThatCorrectStaticInfoIsGottenFromTracker() {
        //Arrange
        let task = taskModelCreator.createTask(from: taskStaticIfo)
       taskProgressTracker = TaskProgressTracker(task: task)
        //Act
        let taskStaticInfoFromTracker = taskProgressTracker.getStaticInfo()
        //Assert
        XCTAssert(taskStaticIfo == taskStaticInfoFromTracker, "taskStaticIfo \(taskStaticIfo), taskStaticInfoFromModelHandler \(taskStaticInfoFromTracker)")
    }
}

