//
//  deadLineVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DeadLineVC: UIViewController, DeadLineReporting, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var deadLinesTochose: [TimeInterval] = []
    private var deadLineReceiver: DeadLineReceiving!
    
    @IBOutlet weak var deadLinePickerView: UIPickerView! {
        didSet {
            deadLinePickerView.dataSource = self
            deadLinePickerView.delegate = self
            let chosenRow = deadLinePickerView.selectedRow(inComponent: 0)
            let chosenDeadLine = deadLinesTochose[chosenRow]
            deadLineReceiver.receiveDeadLine(chosenDeadLine)
        }
    }
    
    //MARK: DeadLineReporting
    func setDeadLineRerceiver(_ receiver: DeadLineReceiving, deadLinesToChose: [TimeInterval]) {
        self.deadLineReceiver = receiver
        self.deadLinesTochose = deadLinesToChose
    }
    
    //MARK: PickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deadLinesTochose.count
    }
    //MARK: PickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let deadLineTitle = String(deadLinesTochose[row])
        return deadLineTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let chosenDeadLine = deadLinesTochose[row]
        deadLineReceiver.receiveDeadLine(chosenDeadLine)
    }
}
