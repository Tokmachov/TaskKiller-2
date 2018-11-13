//
//  Task+CoreDataProperties.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var dateCreated: NSDate?
    @NSManaged public var deadLine: Int16
    @NSManaged public var taskDescription: String?
    @NSManaged public var postponableDeadLine: Int16
    @NSManaged public var timeSpentInProgress: Int16
    @NSManaged public var periodsOfProcess: NSSet?
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for periodsOfProcess
extension Task {

    @objc(addPeriodsOfProcessObject:)
    @NSManaged public func addToPeriodsOfProcess(_ value: Period)

    @objc(removePeriodsOfProcessObject:)
    @NSManaged public func removeFromPeriodsOfProcess(_ value: Period)

    @objc(addPeriodsOfProcess:)
    @NSManaged public func addToPeriodsOfProcess(_ values: NSSet)

    @objc(removePeriodsOfProcess:)
    @NSManaged public func removeFromPeriodsOfProcess(_ values: NSSet)

}

// MARK: Generated accessors for tags
extension Task {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
