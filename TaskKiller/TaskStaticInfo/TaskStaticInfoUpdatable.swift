//
//  TaskStaticInfoUpdatable.swift
//  TaskKiller
//
//  Created by mac on 29/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStaticInfoUpdatable {
    func updateStaticInfo(_ staticInfoSource: TaskStaticInfoCreating)
}

