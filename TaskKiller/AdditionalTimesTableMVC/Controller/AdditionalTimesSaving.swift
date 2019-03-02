//
//  AdditionalTimesSaving.swift
//  TaskKiller
//
//  Created by mac on 02/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
protocol AdditionalTimesSaving {
    func saveAdditionalTimes(_ times: TimesModelForTable)
}
extension AdditionalTimesSaving {
    func saveAdditionalTimes(_ times: TimesModelForTable) {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: times, requiringSecureCoding: false)
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        userDefaults!.set(data, forKey: UserDefaultsKeys.additionalTimesKey)
    }
}


