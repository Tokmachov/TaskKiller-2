//
//  PeriodModel+CoreDataProperties.swift
//  TaskTracker
//
//  Created by mac on 04/05/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//
//

import Foundation
import CoreData


extension PeriodModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeriodModel> {
        return NSFetchRequest<PeriodModel>(entityName: "PeriodModel")
    }

    @NSManaged public var dateFinished: NSDate?
    @NSManaged public var dateStarted: NSDate?
    @NSManaged public var task: TaskModel?

}
