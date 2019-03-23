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
    func deleteTagFromMemory(_ tag: Tag) {
        PersistanceService.context.delete(tag.tagModel)
        PersistanceService.saveContext()
    }
    
    func createTag(from name: String, and color: UIColor) -> Tag {
        let tagModel = createTagModel(from: name, and: color)
        let tag = TagModelAdapter(tagModel: tagModel)
        return tag
    }
    func createTag(from tagModel: TagModel) -> Tag {
        return TagModelAdapter(tagModel: tagModel)
    }
}

extension TagFactoryImp {
    private func createTagModel(from name: String, and color: UIColor) -> TagModel {
        let tagModel = TagModel(context: PersistanceService.context)
        tagModel.name = name
        tagModel.color = color
        tagModel.dateCreated = Date() as NSDate
        tagModel.positionInUserSelectedOrder = getOrderNumberForNewTag()
        PersistanceService.saveContext()
        return tagModel
    }
    private func getOrderNumberForNewTag() -> Int16 {
        let fetchRequest: NSFetchRequest = TagModel.fetchRequest()
        var numberOfCreatedTags: Int = 0
        do {
            numberOfCreatedTags = try PersistanceService.context.count(for: fetchRequest)
        } catch {
            print("error occured when getting amount of created Tags")
        }
        return Int16(numberOfCreatedTags)
    }
}
