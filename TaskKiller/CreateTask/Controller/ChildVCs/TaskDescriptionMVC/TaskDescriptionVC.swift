//
//  TaskDescriptionVC.swift
//  TaskKiller
//
//  Created by mac on 26/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskDescriptionVC: UIViewController, UITextViewDelegate {
    //MARK: Model
    private var taskDescription: String = "" {
        didSet {
            delegate.taskDescriptionVC(self, didEnterDescription: taskDescription)
        }
    }
    var delegate: TaskDescriptionVCDelegate!
    
    @IBOutlet weak var textView: UITextView!
    
    //hide key board
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            self.taskDescription = textView.text
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        taskDescription = textView.text
    }
    func finishTextInput() {
        textView.resignFirstResponder()
    }
}
