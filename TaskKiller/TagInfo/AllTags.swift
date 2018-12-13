//
//  TagsInfosList.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct AllTags {
    
    private var tagsInfosList: [Tag] = []
    
    func getTagsInfos() -> [Tag] {
        return tagsInfosList
    }
    func getStringOfAllTagNames() -> String {
        return tagsInfosList.reduce("", { result, tag in
            result + tag.projectName
        })
    }
    mutating func addTagInfo(_ tagInfo: Tag) {
        tagsInfosList.append(tagInfo)
    }
}

extension AllTags: Equatable {
    static func == (lhs: AllTags, rhs: AllTags) -> Bool {
        return lhs.tagsInfosList == rhs.tagsInfosList
    }
}
