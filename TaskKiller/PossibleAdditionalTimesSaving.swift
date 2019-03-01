//
//  PossibleAdditionTimesSaving.swift
//  TaskKiller
//
//  Created by mac on 01/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol PossibleAdditionalTimesSaving {
    func savePossibleAdditionalTimes(_ timesSource: PossibleAdditionalTimesReadable)
}

extension PossibleAdditionalTimesSaving {
    func savePossibleAdditionalTimes(_ timesSource: PossibleAdditionalTimesReadable) {
        guard let userDeaults = UserDefaults(suiteName: TaskKillerGroupID.id) else { fatalError() }
        let possibleAdditionalWorkTimes = timesSource.possibleAdditionalWorkTimesForIds
        let possibleBreakTimes = timesSource.possibleBreakTimesForIds
        userDeaults.set(possibleAdditionalWorkTimes, forKey: UserDefaultsKeys.additionalWorkTimesForIds)
        userDeaults.set(possibleBreakTimes, forKey: UserDefaultsKeys.breakTimesForIds)
    }
}
