//
//  PeriodModel+CoreDataProperties.swift
//  TaskKiller
//
//  Created by mac on 14/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
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
