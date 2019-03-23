//
//  ValidDay.swift
//  TaskKiller
//
//  Created by mac on 09/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct ValidDay: Day {
 
    
    var dayNumberDescription: String {
        if String(dayNumber).count == 2 {
            return "\(dayNumber) "
        } else {
            return "\(dayNumber)  "
        }
        
    }
    var workHoursDescriotion: String {
        return workHours != nil ? "\(workHours!) h" : ""
    }
    var dayType: DayType
    private var dayNumber: Int
    private var workHours: Int?
    
    init(dayNumber: Int, workHours: Int?) {
        self.dayNumber = dayNumber
        self.workHours = workHours
        self.dayType = .validDay
    }
}
