//
//  AdditionalTimesTableViewModelController.swift
//  TaskKiller
//
//  Created by mac on 02/05/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct AdditionalTimesTableViewModelController {
    
    var additionalTimesStore: AdditionalTimesStore
    
    var numberOfAdditionalTimesSections: Int {
        return AdditionalTime.AdditionalTimeType.allCases.count
    }
    func numberOfAdditionalTimes(inSection sectionNumber: Int) -> Int {
        let additionalTimeType = AdditionalTime.AdditionalTimeType(rawValue: sectionNumber)
        let timesList = additionalTimesList(ofType: additionalTimeType!)
        return timesList.count
    }
    func sectionTitle(forSection sectionNumber: Int) -> String {
        let additionalTimeType = AdditionalTime.AdditionalTimeType(rawValue: sectionNumber)
        switch additionalTimeType! {
        case .workTime:
            return "Additional work times"
        case .breakTime:
            return "Additional break times"
        }
    }
    func additionalTime(forIndexPath indexPath: IndexPath) -> AdditionalTime {
        let additionalTimeType = AdditionalTime.AdditionalTimeType(rawValue: indexPath.section)
        let timesList = additionalTimesList(ofType: additionalTimeType!)
        return timesList[indexPath.row]
    }
    func add(_ time: AdditionalTime) {
        additionalTimesStore.additionalTimes.append(time)
    }
    func removeAdditionalTime(atIndexPath indexPath: IndexPath) {
        let additionalTimeType = AdditionalTime.AdditionalTimeType(rawValue: indexPath.section)
        let timesList = additionalTimesList(ofType: additionalTimeType!)
        let additionalTime = timesList[indexPath.row]
        let index = additionalTimesStore.additionalTimes.firstIndex { $0 ===  additionalTime}
        additionalTimesStore.additionalTimes.remove(at: index!)
    }
    
    func changeToggleStateOfAdditionalTime(atIndexPath indexPath: IndexPath, newTogglesState: AdditionalTime.ToggleState) {
        let additionalTimeType = AdditionalTime.AdditionalTimeType(rawValue: indexPath.section)
        let timesList = additionalTimesList(ofType: additionalTimeType!)
        let additionalTime = timesList[indexPath.row]
        additionalTime.toggleState = newTogglesState
    }
    private func additionalTimesList(ofType type: AdditionalTime.AdditionalTimeType) -> [AdditionalTime] {
        switch type {
        case .workTime:
            return additionalTimesStore.additionalTimes.filter { $0.type == .workTime }.sorted { $0.time < $1.time }
        case .breakTime:
            return additionalTimesStore.additionalTimes.filter { $0.type == .breakTime }.sorted { $0.time < $1.time }
        }
    }
}
