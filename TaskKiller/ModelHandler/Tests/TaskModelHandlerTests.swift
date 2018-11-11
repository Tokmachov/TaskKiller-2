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
    
    var taskModelHandler: TaskModelCreating & TaskInfoGetableHandler = TaskModelHandler()
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
    
    func testThatTaskStaticInfoTakenFormTaskModelHandlerAfterCreationIsEqualToTaskModelInfoHandlerWasCreatedFrom() {
        //Arrange
        taskModelHandler.createTask(from: taskStaticIfo)
        //Act
        let taskStaticInfoFromModelHandler = taskModelHandler.getStaticInfo()
        //Assert
        XCTAssert(taskStaticIfo == taskStaticInfoFromModelHandler, "taskStaticIfo \(taskStaticIfo), taskStaticInfoFromModelHandler \(taskStaticInfoFromModelHandler)")
    }
}

