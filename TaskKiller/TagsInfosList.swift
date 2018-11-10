//
//  TagsInfosList.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TagsInfosList {
    
    private var tagsInfosList: [TagInfo] = []
    
    func getTagsInfos() -> [TagInfo] {
        return tagsInfosList
    }
    func getStringOfAllTagNames() -> String {
        return tagsInfosList.reduce("", { result, tag in
            result + tag.projectName
        })
    }
    mutating func addTagInfo(_ tagInfo: TagInfo) {
        tagsInfosList.append(tagInfo)
    }
}
