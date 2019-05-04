//
//  TagModel+CoreDataProperties.swift
//  TaskTracker
//
//  Created by mac on 04/05/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//
//

import Foundation
import CoreData


extension TagModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TagModel> {
        return NSFetchRequest<TagModel>(entityName: "TagModel")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var positionInUserSelectedOrder: Int16
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
