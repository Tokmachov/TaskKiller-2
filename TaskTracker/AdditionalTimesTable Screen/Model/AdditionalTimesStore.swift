//
//  AdditionalTimesStore.swift
//  TaskKiller
//
//  Created by mac on 02/05/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

class AdditionalTimesStore: NSObject, NSCoding {
    
    enum CodingKeys {
        static let additionalTimesKey = "AdditionalTimes"
    }
    var additionalTimes = [AdditionalTime]()
    
    override init() {
        super.init()
    }
    //MARK: NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let additionalTimes = aDecoder.decodeObject(forKey: CodingKeys.additionalTimesKey) as? [AdditionalTime] else {
            return nil
        }
        self.additionalTimes = additionalTimes
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(additionalTimes, forKey: CodingKeys.additionalTimesKey)
    }
}
