//
//  TaskStateChangesReceiving.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 21/11/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStateChangesReceiving: AnyObject {
    func taskStateDidChangedToStarted()
    func taskStateDidChangedToStopped(_ taskState: TaskProgressInfoGetable)
}
