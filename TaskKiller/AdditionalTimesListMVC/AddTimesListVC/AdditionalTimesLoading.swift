//
//  AdditionalTimesLoading.swift
//  TaskKiller
//
//  Created by mac on 01/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol AdditionalTimesLoading {
    func loadAdditionalTimes() -> AdditionalTimes
}
extension AdditionalTimesLoading {
    func loadAdditionalTimes() -> AdditionalTimes {
        guard let data = loadAdditionalTimesDataFromUserDefaults() else { return AdditionalTimes() }
        guard let additionalTimes = unarchiveAdditionalTimesData(data) else { fatalError() }
        return additionalTimes
    }
    private func loadAdditionalTimesDataFromUserDefaults() -> Data? {
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        let additionalTimesData = userDefaults?.data(forKey: UserDefaultsKeys.additionalTimesKey)
        return additionalTimesData
    }
    private func unarchiveAdditionalTimesData(_ data: Data) -> AdditionalTimes? {
        let additionalTimes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AdditionalTimes
        return additionalTimes!
    }
}
