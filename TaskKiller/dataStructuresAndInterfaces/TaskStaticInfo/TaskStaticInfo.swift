//
//  StaticInfo.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.



import Foundation

struct TaskStaticInfo {

    var taskDescription: String
    var initialDeadLine: TimeInterval
    var tags: ImmutableTagStore
}

extension TaskStaticInfo: Equatable {
    static func == (lhs: TaskStaticInfo, rhs: TaskStaticInfo) -> Bool {
        return lhs.taskDescription == rhs.taskDescription
    }
}
