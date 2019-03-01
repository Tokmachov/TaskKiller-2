//
//  AdditionalTimeRemovable.swift
//  TaskKiller
//
//  Created by mac on 28/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol AdditionalTimeRemovable {
    func removeAdditionalWorkTime(atIndex index: Int)
    func removeBreakTime(atIndex index: Int)
}
