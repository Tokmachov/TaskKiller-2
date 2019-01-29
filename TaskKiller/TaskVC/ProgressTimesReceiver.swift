//
//  ProgressTimesReceiver.swift
//  TaskKiller
//
//  Created by mac on 27/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol ProgressTimesReceiver: AnyObject {
    func receiveProgressTimes(_ progressTimesSource: TaskProgressTimesCreating)
}
