//
//  AddTimes.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

class AdditionalTimes: NSObject,NSCoding, PossibleBreakTimesReadable, PossibleAdditionalWorkTimesReadable, RepresentableInSectionedTable, AdditionalTimeAddable, AdditionalTimesEditing, AdditionalTimeRemovable {
    
    private var additionalTimesIdsAndValues = [String : AdditionalTime]()
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        guard let additionalTimesIdsAndValues = aDecoder.decodeObject(forKey: "additionalTimesIdsAndValues") as? [String : AdditionalTime] else { return nil }
        self.additionalTimesIdsAndValues = additionalTimesIdsAndValues
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(additionalTimesIdsAndValues, forKey: "additionalTimesIdsAndValues")
    }
    //PossibleAdditionalWorkTimesReadable
    var possibleAdditionalWorkTimesForIds: [String : TimeInterval] {
        return additionalTimesIdsAndValues.filter { $0.value.toggleState == .on && $0.value.type == .additionalWorkTime }.mapValues { $0.time }
    }
    //PossibleBreakTimesReadable
    var possibleBreakTimesForIds: [String : TimeInterval] {
        return additionalTimesIdsAndValues.filter { $0.value.toggleState == .on && $0.value.type == .breakTime }.mapValues { $0.time }
    }
    //AdditionalTimeAddable
    func addAdditionalTime(_ time: AdditionalTime) {
        additionalTimesIdsAndValues[UUID().uuidString] = time
    }
    
    //RepresentableInSectionedTable
    var numberOfAdditionalTimesTypes: Int {
        return 2
    }
    
    var titleForAdditionalWorkTimesSection: String {
        return "Additional work times"
    }
    
    var titleForAdditionalBreakTimesSection: String {
        return "Additional break times"
    }
    
    var additionalWorkTimes: [AdditionalTime] {
        return additionalTimesIdsAndValues.map { $0.value }.filter { $0.type == .additionalWorkTime }.sorted { $0.time < $1.time }
    }
    
    var additionalBreakTimes: [AdditionalTime] {
        return additionalTimesIdsAndValues.map { $0.value }.filter { $0.type == .breakTime }.sorted { $0.time < $1.time }
    }
    
    //MARK: AdditionalTimesChangable
    func changeToggleStateOfAdditionalWorkTime(atIndex index: Int, to togglesState: ToggleState) {
        let additionalTime = additionalWorkTimes[index]
        additionalTime.toggleState = togglesState
    }
    func changeToggleStateOfBreakTime(atIndex index: Int, to togglesState: ToggleState) {
        let additionalTime = additionalBreakTimes[index]
        additionalTime.toggleState = togglesState
    }
    //MARK: AdditionalTimeRemvable
    func removeAdditionalWorkTime(atIndex index: Int) {
        let additionalWorkTime = additionalWorkTimes[index]
        let additionalWorkTimeKey = additionalTimesIdsAndValues.first { $0.value === additionalWorkTime }!.key
        _ = additionalTimesIdsAndValues.removeValue(forKey: additionalWorkTimeKey)
    }
    func removeBreakTime(atIndex index: Int) {
        let additionalBreakTime = additionalBreakTimes[index]
        let additionalBreakTimeKey = additionalTimesIdsAndValues.first { $0.value === additionalBreakTime }!.key
        _ = additionalTimesIdsAndValues.removeValue(forKey: additionalBreakTimeKey)
    }
}
