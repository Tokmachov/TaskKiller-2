//
//  AdditionalTimesChangeble.swift
//  TaskKiller
//
//  Created by mac on 26/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol AdditionalTimesEditing {
    func changeToggleStateOfAdditionalWorkTime(atIndex index: Int, to togglesState: ToggleState)
    func changeToggleStateOfBreakTime(atIndex index: Int, to togglesState: ToggleState)
}
