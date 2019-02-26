//
//  AdditionalTimesChangeble.swift
//  TaskKiller
//
//  Created by mac on 26/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol AdditionalTimesChangable {
    func changeAdditionalWorkTime(atIndex index: Int, toNewTogglesState togglesState: ToggleState)
    func changeBreakkTime(atIndex index: Int, toNewTogglesState togglesState: ToggleState)
}
