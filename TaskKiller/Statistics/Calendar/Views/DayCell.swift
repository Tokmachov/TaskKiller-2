//
//  DayCell.swift
//  TaskKiller
//
//  Created by mac on 10/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumberLabel: UILabel!
    
    func update(with dayModel: Day) {
        let dayNumber = dayModel.dayNumberDescription
        let dayType = dayModel.dayType
        let workHoursDescription = dayModel.workHoursDescriotion
        updateAppearance(forDayType: dayType)
        dayNumberLabel.setText(dayNumber)
    }
    private func updateAppearance(forDayType type: DayType) {
        switch type {
        case .placeHolder: makePlaceHolderAppearance()
        case .validDay: makeValidDayAppearance()
        }
    }
    private func makePlaceHolderAppearance() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    }
    private func makeValidDayAppearance() {
        backgroundColor = UIColor.white.withAlphaComponent(1)
    }
}
