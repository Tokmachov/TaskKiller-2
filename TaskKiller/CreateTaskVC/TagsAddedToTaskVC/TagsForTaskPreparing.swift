//
//  TagsForTaskPreparing.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TagsForTaskPreparing {
    func setDelegate(_ delegate: DropAreaForRemovingTagFromTaskPreparingDelegate)
    func remove(_ tag: Tag)
    
}
