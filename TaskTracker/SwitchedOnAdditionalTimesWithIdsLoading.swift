//
//  PossibleAdditionalTimesLoading.swift
//  TaskKiller
//
//  Created by mac on 27/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

typealias Id = String
typealias AdditionalTimeValue = TimeInterval

protocol SwitchedOnAdditionalTimesWithIdsLoading {
    func loadSwitchedOnWorkTimesWithIds() -> [Id : AdditionalTimeValue]
    func loadSwitchedOnBreakTimesWithIds() -> [Id : AdditionalTimeValue]
}
extension SwitchedOnAdditionalTimesWithIdsLoading {
    func loadSwitchedOnWorkTimesWithIds() -> [Id : AdditionalTimeValue] {
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        let possibleAdditionalTimes = userDefaults?.dictionary(forKey: UserDefaultsKeys.additionalWorkTimesForIds) as? [Id : AdditionalTimeValue]
        return possibleAdditionalTimes!
    }
    func loadSwitchedOnBreakTimesWithIds() -> [Id : AdditionalTimeValue] {
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        let possibleBreakTimes = userDefaults?.dictionary(forKey: UserDefaultsKeys.breakTimesForIds) as? [Id : AdditionalTimeValue]
        return possibleBreakTimes!
    }
}
