//
//  GoalDescriptionVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskDescriptionVC: UIViewController, TaskDescriptionReporting, UITextFieldDelegate {
    
    private let emptyTaskDescription = ""
    
    private var taskDescriptionReceiver: TaskDescriptionReceiving!
    @IBOutlet weak var taskDescriptionTextField: UITextField! {
        didSet {
            taskDescriptionTextField.delegate = self
            taskDescriptionReceiver.receiveTaskDescription(emptyTaskDescription)
        }
    }
    
    //MARK: TaskDescriptionReporting
    func setTaskDescriptionReceiver(_ receiver: TaskDescriptionReceiving) {
        self.taskDescriptionReceiver = receiver
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskDescriptionTextField.resignFirstResponder()
        return true
    }
    @IBAction func didEditedText(_ textField: UITextField) {
        let taskDescription = textField.text ?? "Error of typing"
        taskDescriptionReceiver.receiveTaskDescription(taskDescription)
    }
}
