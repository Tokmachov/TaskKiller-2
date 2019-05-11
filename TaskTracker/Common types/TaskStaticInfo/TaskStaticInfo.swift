//
//  StaticInfo.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.



import Foundation

struct TaskStaticInfo {

    var description: String
    var initialDeadLine: TimeInterval
    var tagsStore: ImmutableTagStore
}

extension TaskStaticInfo: Equatable {
    static func == (lhs: TaskStaticInfo, rhs: TaskStaticInfo) -> Bool {
        return lhs.description == rhs.description
    }
}
