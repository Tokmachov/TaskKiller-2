//
//  TaskModel+CoreDataProperties.swift
//  TaskKiller
//
//  Created by mac on 15/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
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
    @NSManaged public var tags: NSOrderedSet?

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

    @objc(insertObject:inTagsAtIndex:)
    @NSManaged public func insertIntoTags(_ value: TagModel, at idx: Int)

    @objc(removeObjectFromTagsAtIndex:)
    @NSManaged public func removeFromTags(at idx: Int)

    @objc(insertTags:atIndexes:)
    @NSManaged public func insertIntoTags(_ values: [TagModel], at indexes: NSIndexSet)

    @objc(removeTagsAtIndexes:)
    @NSManaged public func removeFromTags(at indexes: NSIndexSet)

    @objc(replaceObjectInTagsAtIndex:withObject:)
    @NSManaged public func replaceTags(at idx: Int, with value: TagModel)

    @objc(replaceTagsAtIndexes:withTags:)
    @NSManaged public func replaceTags(at indexes: NSIndexSet, with values: [TagModel])

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: TagModel)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: TagModel)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSOrderedSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSOrderedSet)

}
