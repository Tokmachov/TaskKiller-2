//
//  TagModel+CoreDataProperties.swift
//  TaskKiller
//
//  Created by mac on 20/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
//

import Foundation
import CoreData


extension TagModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagModel> {
        return NSFetchRequest<TagModel>(entityName: "TagModel")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension TagModel {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: TaskModel)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: TaskModel)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
