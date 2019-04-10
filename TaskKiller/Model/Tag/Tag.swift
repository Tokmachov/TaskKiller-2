//
//  Tag.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol Tag  {
    var name: String { get set }
    var color: UIColor { get set }
    var tagModel: TagModel { get }
}

struct TagImp: Tag {
    
    var tagModel: TagModel
    var name: String {
        set {
            tagModel.name = newValue
            PersistanceService.saveContext()
        }
        get {
            guard let name = tagModel.name else { fatalError() }
            return name
        }
    }
    var color: UIColor {
        set {
            tagModel.color = newValue
            PersistanceService.saveContext()
        }
        get {
            guard let color = tagModel.color else { fatalError() }
            return color as! UIColor
        }
    }
    init(tagModel: TagModel) {
        self.tagModel = tagModel
    }
}

extension TagImp: Equatable {}
