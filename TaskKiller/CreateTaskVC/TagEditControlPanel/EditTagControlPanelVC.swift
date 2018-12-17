//
//  EditTagControlPanelVC.swift
//  TaskKiller
//
//  Created by mac on 15/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
class EditTagControlPanelVC: UIViewController, TagInfoReporting {
    
    //MARK: TagInfoReporting
    private weak var tagInfoReceiver: TagInfoReceiving!
    func setTagInfoReceiver(_ receiver: TagInfoReceiving) {
        self.tagInfoReceiver = receiver
    }
    
    let addAndEditTagButtonsAnimationTime: Double = 0.5
    let creationControlsAnimationTime: Double = 2
    let opaqeAlpfa: CGFloat = 1
    let transparentAlpha: CGFloat = 0
    let doneEditingButtonAnimationTime: Double = 1
    let doneEditingButtonXPosition: CGFloat = 0.0
    
    @IBOutlet weak var addTag: UIButton!
    @IBOutlet weak var editTag: UIButton!
    
    @IBOutlet weak var tagNameInput: UITextField!
    @IBOutlet weak var creationControlsStack: UIStackView!
    @IBOutlet weak var creationControlsConstraint: NSLayoutConstraint!
    @IBOutlet weak var doneEditing: UIButton!
    @IBOutlet weak var doneEditingXConstraint: NSLayoutConstraint!
    
    //MARK: VC life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveCreationControlsOffScreen()
        moveAddAndEditTagButtonsOnScreen()
        moveDoneEditingButtonOffScreen()
    }
    
    //MARK: Events
    @IBAction func addTagPressed() {
        moveAddAndEditTagButtonsOffScreen()
        moveCreationControlsOnScreen()
    }
    @IBAction func editTagButtonPressed() {
        moveAddAndEditTagButtonsOffScreen()
        moveDoneEditingButtonOnScreen()
    }
    @IBAction func doneTagCreationButtonPressed() {
        moveCreationControlsOffScreen()
        moveAddAndEditTagButtonsOnScreen()
    }
    @IBAction func doneEditingButtonPressed() {
        moveDoneEditingButtonOffScreen()
        moveAddAndEditTagButtonsOnScreen()
    }
    @IBAction func choseColorButtonPressed() {
        
    }
}
//MARK: AddButton, EditButton movements and animations
extension EditTagControlPanelVC {
    private func moveAddAndEditTagButtonsOffScreen() {
        moveAddTagOffScreen()
        moveEditTagOffScreen()
    }
    private func moveAddAndEditTagButtonsOnScreen() {
        moveAddTagOnScreen()
        moveEditTagOnScreen()
    }
    private func moveAddTagOffScreen() {
        fadeViewWithAnimation(addTag, then: { [weak self ] in
            guard let self = self else { fatalError() }
            self.addTag.hide() })
    }
    
    private func moveAddTagOnScreen() {
        UIView.animate(withDuration: addAndEditTagButtonsAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.addTag.alpha = self.opaqeAlpfa
            }, completion: { [weak self] (isAnimationFinished) in
                guard let self = self else { fatalError() }
                self.addTag.show()
        })
    }
    
    private func moveEditTagOffScreen() {
        fadeViewWithAnimation(editTag, then: { [weak self ] in
            guard let self = self else { fatalError() }
            self.editTag.hide() })
    }
    private func moveEditTagOnScreen() {
        UIView.animate(withDuration: addAndEditTagButtonsAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.editTag.alpha = self.opaqeAlpfa
            }, completion: { [weak self] (isAnimationFinished) in
                guard let self = self else { fatalError() }
                self.editTag.show()
        })
    }
    private func fadeViewWithAnimation(_ view: UIView, then animationCompletion: @escaping ()->()) {
        UIView.animate(withDuration: addAndEditTagButtonsAnimationTime, animations: { [weak view, weak self] in
            guard let view = view,
                  let self = self else { fatalError() }
            view.alpha = self.transparentAlpha
            }, completion: { (isFinished) in
                animationCompletion()
        })
    }
}

//MARK: CreationControls movements and animations
extension EditTagControlPanelVC {
    private func moveCreationControlsOffScreen() {
        UIView.animate(withDuration: creationControlsAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.creationControlsConstraint.constant = 2 * self.view.bounds.width
            self.creationControlsStack.alpha = self.transparentAlpha
            }, completion: nil)
    }
    private func moveCreationControlsOnScreen() {
        UIView.animate(withDuration: creationControlsAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.creationControlsConstraint!.constant = self.view.bounds.width / 10
            self.creationControlsStack.alpha = self.opaqeAlpfa
        }, completion: nil)
    }
}
//MARK: DoneEditingButton movements
extension EditTagControlPanelVC {
    private func moveDoneEditingButtonOffScreen() {
        UIView.animate(withDuration: doneEditingButtonAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.doneEditing.alpha = self.transparentAlpha
            self.doneEditingXConstraint.constant = 2 * self.view.bounds.width
        }
        , completion: nil)
    }
    private func moveDoneEditingButtonOnScreen() {
        UIView.animate(withDuration: doneEditingButtonAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.doneEditing.alpha = self.opaqeAlpfa
            self.doneEditingXConstraint.constant = self.doneEditingButtonXPosition
            }
            , completion: nil)
    }
}
