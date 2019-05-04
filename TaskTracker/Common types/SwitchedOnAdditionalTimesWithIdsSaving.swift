//
//  PossibleAdditionTimesSaving.swift
//  TaskKiller
//
//  Created by mac on 01/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol SwitchedOnAdditionalTimesWithIdsSaving {
    func saveSwitchedOnAdditionalWorkTimesAndIds(_ times: SwitchedOnAdditionalWorkTimesAndIds)
    func saveSwitchedOnAdditionalBreakTimesAndIds(_ times: SwitchedOnAdditionalBreakTimesAndIds)
}

extension SwitchedOnAdditionalTimesWithIdsSaving {
    func saveSwitchedOnAdditionalWorkTimesAndIds(_ times: SwitchedOnAdditionalWorkTimesAndIds) {
        guard let userDeaults = UserDefaults(suiteName: TaskKillerGroupID.id) else { fatalError() }
        userDeaults.set(times, forKey: UserDefaultsKeys.additionalWorkTimesForIds)
    
    }
    func saveSwitchedOnAdditionalBreakTimesAndIds(_ times: SwitchedOnAdditionalBreakTimesAndIds) {
        guard let userDeaults = UserDefaults(suiteName: TaskKillerGroupID.id) else { fatalError() }
        userDeaults.set(times, forKey: UserDefaultsKeys.breakTimesForIds)
    }
}
