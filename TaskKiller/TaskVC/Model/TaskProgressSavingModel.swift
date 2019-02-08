//
//  File.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 19.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
typealias  TaskProgressSavingModel = TaskInitiatable & TaskProgressTimesCreating & TaskStaticInfoCreating & TaskProgressSaving & TimeLeftToDeadLineGetable & DeadlinePostponable
