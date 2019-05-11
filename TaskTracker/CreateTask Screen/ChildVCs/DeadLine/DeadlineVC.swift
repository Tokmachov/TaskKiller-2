//
//  DeadlineVC.swift
//  TaskKiller
//
//  Created by mac on 25/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DeadlineVC: UIViewController {
    
    //MARK: model
    private var deadline: TimeInterval? {
        didSet {
            updateDeadlineButtonTitle()
            delegate.deadlineVC(self, didChooseDeadline: deadline!)
        }
    }
    
    //MARK: State flag
    private var datePickerIsShown = false
    
    //MARK: Delegate
    var delegate: DeadlineVCDelegate!
    
    //MARK: Outlets
    @IBOutlet weak var deadlineButton: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    //MARK: formatter
    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, . second]
        formatter.unitsStyle = .positional
        return formatter
    }()
    
    //MARK: View sizes
    private var viewWithHiddenPickerSize: CGSize {
        let width = view.bounds.width
        let height = deadlineButton.intrinsicContentSize.height
        return CGSize(width: width, height: height)
    }
    private var viewWithShownPickerSize: CGSize {
        let width = view.bounds.width
        let height = deadlineButton.intrinsicContentSize.height + datePickerView.bounds.height
        return CGSize(width: width, height: height)
    }
    //MARK: ViewController life cycle
    override func viewDidLoad() {
        hideDatePicker()
        deadline = datePickerView.countDownDuration
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setInitialDatePickerValue()
    }
    
    //MARK: Actions
    @IBAction func deadlineWasChanged(_ sender: UIDatePicker) {
        deadline = sender.countDownDuration
    }
    
    @IBAction func deadlineButtonWasTapped(_ sender: UIButton) {
        switch datePickerIsShown {
        case true:
            hideDatePicker()
            datePickerIsShown = false
        case false:
            showDatePicker()
            datePickerIsShown = true
            delegate.deadlineVCDidShowDatePicker(self)
        }
       
    }
}
extension DeadlineVC {
    private func showDatePicker() {
        UIView.animate(withDuration: 0.1, animations: {
            self.datePickerView.alpha = 1
        }, completion: { _ in
           self.reportDeadlineViewSizeWithShownPickerToParentVC()
        })
    }
    private func hideDatePicker() {
        UIView.animate(withDuration: 0.1, animations: {
            self.datePickerView.alpha = 0
        }, completion: { _ in
           self.reportDeadlineViewSizeWithHiddenPickerToParentVC()
        })
    }
    private func updateDeadlineButtonTitle() {
        guard let deadline = deadline else {
            deadlineButton.setTitle("Время выполнения", for: .normal)
            return
        }
        let chosenDeadline = formatter.string(from: deadline)
        deadlineButton.setTitle("Время выполнения: \(chosenDeadline!)", for: .normal)
    }
    private func reportDeadlineViewSizeWithHiddenPickerToParentVC() {
        preferredContentSize = viewWithHiddenPickerSize
    }
    private func reportDeadlineViewSizeWithShownPickerToParentVC() {
        preferredContentSize = viewWithShownPickerSize
    }
    private func setInitialDatePickerValue() {
        datePickerView.countDownDuration = 60
    }
}
