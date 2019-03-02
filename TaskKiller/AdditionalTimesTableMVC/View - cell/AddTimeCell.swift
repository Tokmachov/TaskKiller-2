//
//  AddTimeCell.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class AdditionalTimeCell: UITableViewCell {
    
    private lazy var dateComponentsFormater: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second,.minute,.hour]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    private var time: TimeInterval = 0.0 {
        didSet {
            let formattedTime = dateComponentsFormater.string(from: time)!
            timeLabel.setText(formattedTime)
        }
    }
    private var toggleState: ToggleState = .off {
        didSet {
            switch toggleState {
            case .on: timeSwitch.isOn = true
            case .off: timeSwitch.isOn = false
            }
        }
    }
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeSwitch: UISwitch!
    
    func setTime(_ time: TimeInterval) {
        self.time = time
    }
    func setToggleState(_ toggleState: ToggleState) {
       self.toggleState = toggleState
    }
}
