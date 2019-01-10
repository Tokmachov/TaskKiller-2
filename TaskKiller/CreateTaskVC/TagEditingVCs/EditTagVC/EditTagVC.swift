//
//  EditTagVC.swift
//  TaskKiller
//
//  Created by mac on 08/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class EditTagVC: UIViewController {
    
    private var tag: Tag!
    private var tagName: String! {
        didSet {
            tagView.setTagName(tagName)
        }
    }
    private var tagColor: UIColor! {
        didSet {
            tagView.setTagColor(tagColor)
        }
    }
    
    @IBOutlet weak var tagView: TagDummyView!
    @IBOutlet weak var tagNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagNameTextField.delegate = self
        tagNameTextField.text = tag.getName()
        tagName = tag.getName()
        tagColor = tag.getColor()
    }
    @IBAction func colorSelectionButtonPressed(_ sender: ColorSelectionButton) {
        tagColor = sender.getColor()
    }
    @IBAction func editingDidChanged(_ sender: UITextField) {
        tagName = sender.text
    }
    
    func setTagForEditing(_ tag: Tag) {
        self.tag = tag
    }
    @IBAction func doneTagEditing() {
        tag.setName(tagName)
        tag.setColor(tagColor)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func editingIsCancelled() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension EditTagVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tagNameTextField.resignFirstResponder()
        return true
    }
}
