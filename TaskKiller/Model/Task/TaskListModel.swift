//
//  File.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 19.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskListModel {
    var taskDescription: String { get }
    var tagsStore: ImmutableTagStore { get }
}


