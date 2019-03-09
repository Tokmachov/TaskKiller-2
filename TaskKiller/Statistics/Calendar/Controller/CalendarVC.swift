//
//  CalendarVC.swift
//  TaskKiller
//
//  Created by mac on 05/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {
    
    @IBOutlet weak var monthAndYearLabel: UILabel!
    @IBOutlet weak var weekDaysStack: UIStackView!
    override func viewDidLoad() {
        fillWeekDaysNames()
    }
    private func fillWeekDaysNames() {
        let weekDaySymbols = Calendar.current.shortWeekdaySymbols
        for (index, weekDaySybol) in weekDaySymbols.enumerated() {
            let weekDayLabel = weekDaysStack.arrangedSubviews[index] as? UILabel
            weekDayLabel!.setText(weekDaySybol)
        }
    }
}

