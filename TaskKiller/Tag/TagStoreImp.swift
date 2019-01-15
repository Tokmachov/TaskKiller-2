//
//  TagStoreImp.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TagStoreImp: TagStore {

    private var tags = [Tag]()
    
    //MARK: TagsPreparingStore protocol methods
    var count: Int {
        return tags.count
    }
    func getTag(at index: Int) -> Tag {
        return tags[index]
    }
    func index(Of tag: Tag) -> Int? {
        let index = tags.firstIndex(where: { $0.getTagModel() == tag.getTagModel() })
        return index
    }
    func canAdd(_ tag: Tag) -> Bool {
        return !tags.contains(where: { $0.getTagModel() == tag.getTagModel() })
    }
    mutating func add(_ tag: Tag) {
        guard !tags.contains(where: { $0.getTagModel() == tag.getTagModel() }) else { fatalError() }
        tags.append(tag)
    }
    mutating func remove(_ tag: Tag) {
        guard let indexOfTag = tags.firstIndex(where: { $0.getTagModel() == tag.getTagModel() }) else { fatalError() }
        tags.remove(at: indexOfTag)
    }
    mutating func move(from sourceIndex: Int, to destinationIndex: Int) {
        tags = tags.reorderedByMovement(from: sourceIndex, to: destinationIndex)
    }
    
    //MARK: AllTagsGetableStore protocol methods
    func getAllTags() {
        return tags
    }
}
