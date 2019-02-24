//
//  CreateAdditionalTimeVC.swift
//  TaskKiller
//
//  Created by mac on 24/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class CreateAdditionalTimeVC: UIViewController, AdditionalTimesSetable {
    
    private var model: AdditionalTimeWritable!
    private var sliderCurrentValue: Float = 0.0 {
        didSet {
            chosenAdditionalTimeType = choseAdditionalTimeType(forValue: sliderCurrentValue)
        }
    }
    private var chosenAdditionalTimeType = AdditionalTimeType.additionalWorkTime {
        didSet {
            updateChosenAdditionalTimeTypeLabel(withType: chosenAdditionalTimeType)
        }
    }
    private var chosenAdditionalTimeValue: TimeInterval {
        return timePicker.countDownDuration
    }
    //MARK: AdditionalTimesSetable
    func setAdditionalTimes(_ additionalTimes: AdditionalTimeWritable) {
        self.model = additionalTimes
    }
    private var aditionalTimesTypesKeysAndTypes: [Int : AdditionalTimeType ] = [
        0 : .additionalWorkTime,
        1 : .breakTime
    ]
    private var additionalTimesTypesAndTheirStringNames: [AdditionalTimeType : String] = [
        .additionalWorkTime : "Additional work time",
        .breakTime : "Additional break time"
    ]
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var chosenAdditionalTimeTypeLabel: UILabel!
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        moveSliderToClosestDescreteValue(sender)
        sliderCurrentValue = sender.value
    }
    @IBAction func createAdditionalTime() {
        let additionalTime = AdditionalTime(time: chosenAdditionalTimeValue, type: chosenAdditionalTimeType, toggleState: .on)
        model.addAdditionalTime(additionalTime)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func canceledAdditionalTimeCreation() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSlider()
        moveSliderToInitialPosition()
        
    }
}

extension CreateAdditionalTimeVC {
    private func setupSlider() {
        slider.minimumValue = 0
        slider.maximumValue = 1
    }
    private func moveSliderToInitialPosition() {
        slider.setValue(0, animated: true)
        sliderCurrentValue = slider.value
    }
    private func moveSliderToClosestDescreteValue(_ slider: UISlider) {
        let sliderDescreteValue = slider.value.rounded()
        slider.setValue(sliderDescreteValue, animated: true)
    }
    private func choseAdditionalTimeType(forValue sliderVaue: Float) -> AdditionalTimeType {
        let sliderValue = Int(sliderVaue)
        let chosenAdditionalTimeType = aditionalTimesTypesKeysAndTypes[sliderValue]!
        return chosenAdditionalTimeType
    }
    private func updateChosenAdditionalTimeTypeLabel(withType type: AdditionalTimeType) {
        let typeName = additionalTimesTypesAndTheirStringNames[type]!
        chosenAdditionalTimeTypeLabel.setText(typeName)
    }
}
