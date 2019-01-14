//
//  RemoveTagFromTaskDropAreaDelegate.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol PrepareDropAreaForRemovingTagFromTaskDelegate: AnyObject {
    func prepareDropAreaForRemovingTagFromTask()
    func dropAreaForRemovingTagFromTaskNoLongerNeeded()
}
