//
//  PossibleAdditionalTimesLoading.swift
//  TaskKiller
//
//  Created by mac on 27/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

typealias NotificationActionIdentifier = String
typealias AdditionalTimeValue = TimeInterval
protocol PossibleAdditionalTimesLoading {
    func loadPossibleAddtionalWorkTimes() -> [NotificationActionIdentifier : AdditionalTimeValue]
    func loadPossibleBreakTimes() -> [NotificationActionIdentifier : AdditionalTimeValue]
}
extension PossibleAdditionalTimesLoading {
    func loadPossibleAddtionalWorkTimes() -> [NotificationActionIdentifier : AdditionalTimeValue] {
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        let possibleAdditionalTimes = userDefaults?.dictionary(forKey: UserDefaultsKeys.additionalWorkTimesForIds) as? [NotificationActionIdentifier : AdditionalTimeValue]
        return possibleAdditionalTimes!
    }
    func loadPossibleBreakTimes() -> [NotificationActionIdentifier : AdditionalTimeValue] {
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        let possibleBreakTimes = userDefaults?.dictionary(forKey: UserDefaultsKeys.breakTimesForIds) as? [NotificationActionIdentifier : AdditionalTimeValue]
        return possibleBreakTimes!
    }
}
