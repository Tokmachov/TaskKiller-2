//
//  TagNameVC.swift
//  TaskKiller
//
//  Created by mac on 18/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagNameVC: UIViewController, UITextFieldDelegate, NameForTagReporting {
    
    private weak var tagNameControllerDelegate: TagNameControllerDelegate!
    func setNameForTagReceiver(_ receiver: TagNameControllerDelegate) {
        self.tagNameControllerDelegate = receiver
    }
    
    @IBOutlet weak var tagName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagName.delegate = self
    }
    
    //MARK: Textfield methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagName.resignFirstResponder()
        return true
    }
    @IBAction func editingDidChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        tagNameControllerDelegate.tagNameController(self, didChoseTagName: text)
    }
}
