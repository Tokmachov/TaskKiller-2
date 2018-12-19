//
//  TagFactoryImp.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

struct TagFactoryImp: TagFactory {
    static func createTag(from name: String, and color: UIColor) -> Tag {
        let tagModel = createTagModel(from: name, and: color)
        let tag = TagModelAdapter(tagModel: tagModel)
        return tag
    }
}

extension TagFactoryImp {
    static private func createTagModel(from name: String, and color: UIColor) -> TagModel {
        let tagModel = TagModel(context: PersistanceService.context)
        tagModel.name = name
        tagModel.color = color
        PersistanceService.saveContext()
        return tagModel
    }
}
