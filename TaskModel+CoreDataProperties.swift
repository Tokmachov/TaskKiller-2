//
//  TaskModel+CoreDataProperties.swift
//  TaskKiller
//
//  Created by mac on 14/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
//

import Foundation
import CoreData


extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var deadLine: Int16
    @NSManaged public var postponableDeadLine: Int16
    @NSManaged public var taskDescription: String?
    @NSManaged public var timeSpentInProgress: Int16
    @NSManaged public var periodsOfProcess: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for periodsOfProcess
extension TaskModel {

    @objc(addPeriodsOfProcessObject:)
    @NSManaged public func addToPeriodsOfProcess(_ value: PeriodModel)

    @objc(removePeriodsOfProcessObject:)
    @NSManaged public func removeFromPeriodsOfProcess(_ value: PeriodModel)

    @objc(addPeriodsOfProcess:)
    @NSManaged public func addToPeriodsOfProcess(_ values: NSSet)

    @objc(removePeriodsOfProcess:)
    @NSManaged public func removeFromPeriodsOfProcess(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension TaskModel {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagModel)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagModel)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
