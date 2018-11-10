//
//  TaskStaticInfoUpdater.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 10.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct TaskStaticInfoUpdater: TaskStaticInfoUpdating {
    
    func update(_ updatable: TaskStaticInfoSetable, from source: TaskStaticInfoGetable) {
        let taskStaticInfo = source.getStaticInfo()
        var taskStaticInfoUpdatable = updatable
        taskStaticInfoUpdatable.setTaskStaticInfo(staticInfo: taskStaticInfo)
    }
}
