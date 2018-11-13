//
//  TaskProgressTracking.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskModelHandlingProgressEditingDecoratorSetupable {
    func setTaskProgressTracker(_ tracker: IInfoGetableTaskHandler)
}
