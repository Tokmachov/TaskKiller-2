//
//  CreateAdditionalTimeVC.swift
//  TaskKiller
//
//  Created by mac on 24/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class CreateAdditionalTimeVC: UIViewController {
    
    //MARK: model
    private var chosenAdditionalTimeType = AdditionalTime.AdditionalTimeType.workTime {
        didSet {
            updateChosenAdditionalTimeTypeLabel(withType: chosenAdditionalTimeType)
        }
    }
    private var chosenAdditionalTimeValue: TimeInterval {
        return timePicker.countDownDuration
    }
    
    //MARK: Delegate
    var delegate: CreateAdditionalTimeVCDelegate!
    
    //MARK: Outlets
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var chosenAdditionalTimeTypeLabel: UILabel!
    
    //MARK: ViewController lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        moveSliderToInitialPosition()
        updateChosenAdditionalTimeType()
    }
    
    //MARK: Action methods
    @IBAction func sliderMoved(_ sender: UISlider) {
        moveSliderToClosestDescreteValue(sender)
        updateChosenAdditionalTimeType()
    }
    @IBAction func createAdditionalTimeButtonWasPressed() {
        let additionalTime = AdditionalTime(time: chosenAdditionalTimeValue, type: chosenAdditionalTimeType, toggleState: .on)
        delegate.createAdditionalTimeVC(self, didCreateAdditionalTime: additionalTime)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func canceledAdditionalTimeCreation() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func addTestAlarm(_ sender: Any) {
        let testAdditionalTime = AdditionalTime(time: 10, type: chosenAdditionalTimeType, toggleState: .on)
        delegate.createAdditionalTimeVC(self, didCreateAdditionalTime: testAdditionalTime)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
 
}

extension CreateAdditionalTimeVC {
    private func setupSlider() {
        slider.minimumValue = 0
        slider.maximumValue = 1
    }
    private func moveSliderToInitialPosition() {
        slider.setValue(0, animated: true)
    }
    private func moveSliderToClosestDescreteValue(_ slider: UISlider) {
        let sliderDescreteValue = slider.value.rounded()
        slider.setValue(sliderDescreteValue, animated: true)
    }
    private func additionalTimeType(forValue sliderVaue: Float) -> AdditionalTime.AdditionalTimeType {
        let sliderValue = Int(sliderVaue)
        var aditionalTimesTypesForSliderValues: [Int : AdditionalTime.AdditionalTimeType ] = [
            0 : .workTime,
            1 : .breakTime
        ]
        let chosenAdditionalTimeType = aditionalTimesTypesForSliderValues[sliderValue]!
        return chosenAdditionalTimeType
    }
    private func updateChosenAdditionalTimeTypeLabel(withType type: AdditionalTime.AdditionalTimeType) {
        var additionalTimesTypeStringNamesForTypes: [AdditionalTime.AdditionalTimeType : String] = [
            .workTime : "Дополнительное рабочее время",
            .breakTime : "Время отдыха"
        ]
        let typeName = additionalTimesTypeStringNamesForTypes[type]!
        chosenAdditionalTimeTypeLabel.text = typeName
    }
    private func updateChosenAdditionalTimeType() {
        chosenAdditionalTimeType = additionalTimeType(forValue: slider.value)
    }
}

