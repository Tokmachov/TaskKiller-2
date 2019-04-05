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
            delegate.deadlineVC(self, didChoseDeadline: deadline!)
        }
    }
    
    private var datePickerIsShown = false
    
    var delegate: DeadlineVCDelegate!
    
    @IBOutlet weak var deadlineButton: UIButton!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, . second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
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
    
    override func viewDidLoad() {
        hideDatePicker()
        deadline = datePickerView.countDownDuration
    }
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
        }
       
    }
}
extension DeadlineVC {
    private func showDatePicker() {
        UIView.animate(withDuration: 0.1, animations: {
            self.datePickerView.alpha = 1
        }, completion: { _ in
            self.preferredContentSize = self.viewWithShownPickerSize
        })
    }
    private func hideDatePicker() {
        UIView.animate(withDuration: 0.1, animations: {
            self.datePickerView.alpha = 0
        }, completion: { _ in
            self.preferredContentSize = self.viewWithHiddenPickerSize
        })
        
    }
    private func updateDeadlineButtonTitle() {
        guard let deadline = deadline else {
            deadlineButton.setTitle("Chose deadline", for: .normal)
            return
        }
        let chosenDeadline = formatter.string(from: deadline)
        deadlineButton.setTitle("deadline: \(chosenDeadline!)", for: .normal)
    }
}
