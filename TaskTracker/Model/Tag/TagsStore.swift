//
//  TagStore.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol ImmutableTagStore {
    var tags: [Tag] { get }
    var tagsCount: Int { get }
    func tag(at index: Int) -> Tag
    func index(Of tag: Tag) -> Int?
}
protocol MutableTagStore {
    mutating func remove(_ tag: Tag)
    mutating func add(_ tag: Tag)
    mutating func insert(tag: Tag, atIndex index: Int)
    func canAdd(_ tag: Tag) -> Bool
}

typealias TagsStore = ImmutableTagStore & MutableTagStore

import Foundation

struct TagStoreImp: TagsStore {
    var tags = [Tag]()
    var tagsCount: Int {
        return tags.count
    }
    func tag(at index: Int) -> Tag {
        return tags[index]
    }
    func index(Of tag: Tag) -> Int? {
        let index = tags.firstIndex(where: { $0.id == tag.id })
        return index
    }
    func canAdd(_ tag: Tag) -> Bool {
        return !tags.contains(where: { $0.id == tag.id })
    }
    mutating func add(_ tag: Tag) {
        guard !tags.contains(where: { $0.id == tag.id }) else { fatalError() }
        tags.append(tag)
    }
    mutating func remove(_ tag: Tag) {
        guard let indexOfTag = tags.firstIndex(where: { $0.id == tag.id }) else { fatalError() }
        tags.remove(at: indexOfTag)
    }
    mutating func insert(tag: Tag, atIndex index: Int) {
        tags.insert(tag, at: index)
    }
}
