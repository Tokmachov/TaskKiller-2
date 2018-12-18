//
//  EditTagControlPanelVC.swift
//  TaskKiller
//
//  Created by mac on 15/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
class TagEditingControlsPanelVC: UIViewController, TagInfoReporting, ChosenColorReceiving {
    
    private var tagName: String!
    private var tagColor: UIColor!
    
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
    
    let onScreenColorPaneMovementTime = 1.0
    let offScreenColorPaneMovementTime = 1.0
    
    @IBOutlet weak var addTag: UIButton!
    @IBOutlet weak var editTag: UIButton!
    
    @IBOutlet weak var tagNameInput: UITextField!
    @IBOutlet weak var creationControlsStack: UIStackView!
    
    @IBOutlet weak var creationControlsLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var doneEditing: UIButton!
    @IBOutlet weak var doneEditingXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var colorPaineXPosition: NSLayoutConstraint!
    
    @IBOutlet weak var colorPaneCallButton: ColorPaneCallButton!
    
    
    //MARK: VC life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveCreationControlsOffScreen()
        moveAddAndEditTagButtonsOnScreen()
        moveDoneEditingButtonOffScreen()
        moveColorPaneOffScreen()
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
    @IBAction func colorPaneCallButtonPressed() {
        moveColorPaneOnScreen()
    }
    
    //MARK: ChosenColorReceiving
    func colorWasChosen(_ color: UIColor) {
        self.tagColor = color
        colorPaneCallButton.setChosenColor(color)
        moveColorPaneOffScreen()
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Color Pane ChildVC":
            guard let chosenColorReporter = segue.destination as? ChosenColorReporting else { fatalError() }
            chosenColorReporter.setChosenColorReceiver(self)
        default: break
        }
    }
}
//MARK: AddButton, EditButton movements and animations
extension TagEditingControlsPanelVC {
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
extension TagEditingControlsPanelVC {
    private func moveCreationControlsOffScreen() {
        UIView.animate(withDuration: creationControlsAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.creationControlsLeadingConstraint.constant = 2 * self.view.bounds.width
            self.creationControlsStack.alpha = self.transparentAlpha
            }, completion: nil)
    }
    private func moveCreationControlsOnScreen() {
        UIView.animate(withDuration: creationControlsAnimationTime, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.creationControlsLeadingConstraint!.constant = self.view.bounds.width / 10
            self.creationControlsStack.alpha = self.opaqeAlpfa
        }, completion: nil)
    }
}
//MARK: DoneEditingButton movements
extension TagEditingControlsPanelVC {
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

//MARK: ColorPane movements
extension TagEditingControlsPanelVC {
    private func moveColorPaneOffScreen() {
        changeXPositionOfColorPaneToOffscreen()
        animateChangeOfConstraintWithDuration(offScreenColorPaneMovementTime)
    }
    private func moveColorPaneOnScreen() {
        changeXPositionOfColorPanelToOnScreen()
        animateChangeOfConstraintWithDuration(onScreenColorPaneMovementTime)
    }
    
    private func changeXPositionOfColorPaneToOffscreen() {
        colorPaineXPosition.constant = parent!.view.bounds.height
    }
    private func changeXPositionOfColorPanelToOnScreen() {
        colorPaineXPosition.constant = 0
    }
    private func animateChangeOfConstraintWithDuration(_ duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self!.view.layoutIfNeeded()
        }, completion: nil)
    }
}
