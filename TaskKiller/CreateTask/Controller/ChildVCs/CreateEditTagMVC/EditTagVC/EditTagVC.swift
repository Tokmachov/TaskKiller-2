//
//  EditTagVC.swift
//  TaskKiller
//
//  Created by mac on 01/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
class EditTagVC: UITableViewController, UITextFieldDelegate {
    
    private let tagMaximumCharacterLength = TagConstants.tagMaximumCharacterLength
    var tag: Tag! 
    var delegate: EditTagVCDelegate!
    
    @IBOutlet weak var tagColorView: ColorSampleView! {
        didSet {
            tagColorView.chosenColor = tag.color
        }
    }
    @IBOutlet weak var tagNameTextField: UITextField! {
        didSet {
            tagNameTextField.text = tag.name
        }
    }
    
    @IBAction func choseColorButtonWasPressed(_ sender: ColorSelectionButton) {
        tagColorView.chosenColor = sender.color
        print("sender color \(sender.color)")
        print("Color \(tag.color)")
        tag.color = sender.color
        print("Color \(tag.color)")
    }
    @IBAction func tagNameWasChanged(_ sender: UITextField) {
        tag.name = sender.text ?? ""
    }
    
    
    @IBAction func tagEditingIsDone(_ sender: Any) {
        delegate.editTagVC(self, didEditTag: tag)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func tagEditingIsCancelled(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagNameTextField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text ?? "" + string).count <= tagMaximumCharacterLength || string.isEmpty
    }
    
}
