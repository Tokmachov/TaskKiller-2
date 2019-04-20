//
//  TagFactory.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

protocol TagFactory {
    func makeTag(name: String, color: UIColor) -> Tag
    func makeTag(tagModel: TagModel) -> Tag
    func deleteTagFromMemory(_ tag: Tag)
}

struct TagFactoryImp: TagFactory {
    func deleteTagFromMemory(_ tag: Tag) {
        let tagModel = fetchTagModel(withId: tag.id)
        PersistanceService.context.delete(tagModel)
        PersistanceService.saveContext()
    }
    func makeTag(name: String, color: UIColor) -> Tag {
        let tagModel = createTagModel(from: name, and: color)
        let tag = TagImp(tagModel: tagModel)
        return tag
    }
    func makeTag(tagModel: TagModel) -> Tag {
        return TagImp(tagModel: tagModel)
    }
}

extension TagFactoryImp {
    private func createTagModel(from name: String, and color: UIColor) -> TagModel {
        let tagModel = TagModel(context: PersistanceService.context)
        tagModel.name = name
        tagModel.color = color
        tagModel.dateCreated = Date() as NSDate
        tagModel.id = UUID.init().uuidString
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
    private func fetchTagModel(withId id: String) -> TagModel {
        let fetchRequest: NSFetchRequest<TagModel> = TagModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        let fetchedModels = try? PersistanceService.context.fetch(fetchRequest)
        
        guard let tagModel = fetchedModels?.first else { fatalError() }
        return tagModel
    }
}

extension TagFactoryImp {
    struct TagImp: Tag {
        
        private var tagModel: TagModel
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
        var id: String {
            guard tagModel.id != nil else { fatalError() }
            return tagModel.id!
        }
        init(tagModel: TagModel) {
            self.tagModel = tagModel
        }
    }
}

