//
//  Tag.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

struct TagModelAdapter: Tag {
    
    private var adaptee: TagModel
    var name: String {
        set {
            adaptee.name = newValue
            PersistanceService.saveContext()
        }
        get {
            guard let name = adaptee.name else { fatalError() }
            return name
        }
    }
    var color: UIColor {
        set {
           adaptee.color = newValue
            PersistanceService.saveContext()
        }
        get {
            guard let color = adaptee.color else { fatalError() }
            return color as! UIColor
        }
    }
    var tagModel: TagModel {
        return adaptee
    }
    init(tagModel: TagModel) {
        self.adaptee = tagModel
    }
}

extension TagModelAdapter: Equatable {}
