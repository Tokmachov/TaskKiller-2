//
//  UserDefaults.swift
//  TaskKiller
//
//  Created by mac on 26/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

enum AdditionalTimesSavingError: Error {
    case unableToArchiveObject
}

extension UserDefaults {
    func saveObject(_ object: Any, forKey key: String) throws {
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false) else { throw AdditionalTimesSavingError.unableToArchiveObject }
        self.set(data, forKey: key)
    }
}
