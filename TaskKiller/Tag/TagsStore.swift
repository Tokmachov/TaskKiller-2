//
//  TagsInfosList.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TagsStore {
    
    private var tags: [Tag] = []
    
    func getTags() -> [Tag] {
        return tags
    }
    func getStringOfAllTagNames() -> String {
        return tags.reduce("", { result, tag in
            result + tag.getName()
        })
    }
    mutating func addTag(_ tag: Tag) {
        tags.append(tag)
    }
}

extension TagsStore: Equatable {
    static func == (lhs: TagsStore, rhs: TagsStore) -> Bool {
        return lhs.tags == rhs.tags
    }
}
