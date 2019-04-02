//
//  CreateTagVC.swift
//  TaskKiller
//
//  Created by mac on 28/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class CreateTagVC: UITableViewController, UITextFieldDelegate {
    
    let maximunTagNameLength = TagConstants.tagMaximumCharacterLength
    //Mark: model
    private var tagName: String?
    private var tagColor: UIColor?
    var delegate: CreateTagVCDelegate!
    @IBOutlet weak var tagNameTextField: UITextField!
    @IBOutlet weak var chosenColorView: ColorSampleView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
    }
    @IBAction func tagNameWasChanged(_ sender: UITextField) {
        tagName = sender.text ?? ""
    }
    @IBAction func tagColorBottonWasTapped(_ sender: UIButton) {
        let colorButton = sender as! ColorSelectionButton
        tagColor = colorButton.color
        chosenColorView.chosenColor = colorButton.color
    }
 
    @IBAction func tagCreationWasCancelled(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveCreatedTag(_ sender: UIBarButtonItem) {
        let tagName = self.tagName ?? ""
        let tagColor = self.tagColor ?? UIColor.gray
        delegate.createTagVCDelegate(self, didChoseName: tagName, AndColor: tagColor)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return (textField.text ?? "" + string).count <= maximunTagNameLength || string.isEmpty
    }
}
