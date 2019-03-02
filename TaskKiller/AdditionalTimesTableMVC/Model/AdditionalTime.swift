//
//  AdditionalTime.swift
//  TaskKiller
//
//  Created by mac on 24/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

class AdditionalTime: NSObject, NSCoding {
    static let timeKey = "time"
    static let typeKey = "type"
    static let toggleStateKey = "toggleState"
    
    var time: TimeInterval
    var type: AdditionalTimeType
    var toggleState: ToggleState
    
    init(time: TimeInterval, type: AdditionalTimeType, toggleState: ToggleState) {
        self.time = time
        self.type = type
        self.toggleState = toggleState
    }
    required init?(coder aDecoder: NSCoder) {
        self.time = AdditionalTime.decodeTime(withCoder: aDecoder, forKey: AdditionalTime.timeKey)
        self.type = AdditionalTime.decodeTimeType(withCoder: aDecoder, forKey: AdditionalTime.typeKey)!
        self.toggleState = AdditionalTime.decodeToggleState(withCoder: aDecoder, forKey: AdditionalTime.toggleStateKey)!
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(time, forKey: AdditionalTime.timeKey)
        aCoder.encode(type.rawValue, forKey: AdditionalTime.typeKey)
        aCoder.encode(toggleState.rawValue, forKey: AdditionalTime.toggleStateKey)
    }
}

extension AdditionalTime {
    private static func decodeTime(withCoder aDecoder: NSCoder, forKey key: String) -> TimeInterval {
        let time = aDecoder.decodeDouble(forKey: "time")
        guard time != 0.0 else { fatalError("Decoder returned 0 when decoding time for key \(key). key \(key) is invalid for decoding") }
        return time
    }
    private static func decodeTimeType(withCoder aDecoder: NSCoder, forKey key: String) -> AdditionalTimeType? {
        let typeRawValue = aDecoder.decodeInteger(forKey: "type")
        guard typeRawValue != 0 else { fatalError("Decoder returned 0 when decoding typeRawValue for key \(key). key: \(key) in invalid for decoding.") }
        guard let type = AdditionalTimeType.init(rawValue: typeRawValue) else { fatalError(" RawValue \(typeRawValue) is out of AdditionalTimes rawValues range)") }
        return type
    }
    private static func decodeToggleState(withCoder aDecoder: NSCoder,forKey key: String) -> ToggleState? {
        let toggleStateRawValue = aDecoder.decodeInteger(forKey: "toggleState")
        guard toggleStateRawValue != 0 else { fatalError("Decoder returned 0 when decoding toggleStateRowValue for key \(key). key: \(key) in invalid for decoding.") }
        guard let toggleState = ToggleState.init(rawValue: toggleStateRawValue) else { fatalError(" RawValue \(toggleStateRawValue) is out of AdditionalTimes rawValues range)") }
        return toggleState
    }
}
