//
//  AdditionalTimesChangeble.swift
//  TaskKiller
//
//  Created by mac on 26/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol AdditionalTimesEditable {
    func changeToggleStateOfWorkTime(atIndex index: Int, to togglesState: ToggleState)
    func changeToggleStateOfBreakTime(atIndex index: Int, to togglesState: ToggleState)
}
