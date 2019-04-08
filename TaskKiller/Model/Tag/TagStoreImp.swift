//
//  TagStoreImp.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TagStoreImp: TagsStore {

    var tags = [Tag]()
    var count: Int {
        return tags.count
    }
    func tag(at index: Int) -> Tag {
        return tags[index]
    }
    func index(Of tag: Tag) -> Int? {
        let index = tags.firstIndex(where: { $0.tagModel == tag.tagModel })
        return index
    }
    func canAdd(_ tag: Tag) -> Bool {
        return !tags.contains(where: { $0.tagModel == tag.tagModel })
    }
    mutating func add(_ tag: Tag) {
        guard !tags.contains(where: { $0.tagModel == tag.tagModel }) else { fatalError() }
        tags.append(tag)
    }
    mutating func remove(_ tag: Tag) {
        guard let indexOfTag = tags.firstIndex(where: { $0.tagModel == tag.tagModel }) else { fatalError() }
        tags.remove(at: indexOfTag)
    }
    mutating func insert(tag: Tag, atIndex index: Int) {
        tags.insert(tag, at: index)
    }
    //MARK: AllTagsGetableStore protocol methods
    func allTags() -> [Tag] {
        return tags
    }
}
