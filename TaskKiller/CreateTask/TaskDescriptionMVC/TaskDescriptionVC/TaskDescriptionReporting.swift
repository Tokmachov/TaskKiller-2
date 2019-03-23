//
//  TaskDescriptionReporting.swift
//  TaskKiller
//
//  Created by mac on 23/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskDescriptionReporting {
    func setTaskDescriptionReceiver(_ receiver: TaskDescriptionReceiving)
}
