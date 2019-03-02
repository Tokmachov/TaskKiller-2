//
//  PossibleAdditionTimesSaving.swift
//  TaskKiller
//
//  Created by mac on 01/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol SwitchedOnAdditionalTimesWithIdsSaving {
    func saveSwitchedOnAdditionalTimesWithIds(from timesSource: SwitchedOnAdditionalTimesReadable)
}

extension SwitchedOnAdditionalTimesWithIdsSaving {
    func saveSwitchedOnAdditionalTimesWithIds(from timesSource: SwitchedOnAdditionalTimesReadable) {
        guard let userDeaults = UserDefaults(suiteName: TaskKillerGroupID.id) else { fatalError() }
        let workTimes = timesSource.workTimesWithIds
        let breakTimes = timesSource.breakTimesWithIds
        userDeaults.set(workTimes, forKey: UserDefaultsKeys.additionalWorkTimesForIds)
        userDeaults.set(breakTimes, forKey: UserDefaultsKeys.breakTimesForIds)
    }
}
