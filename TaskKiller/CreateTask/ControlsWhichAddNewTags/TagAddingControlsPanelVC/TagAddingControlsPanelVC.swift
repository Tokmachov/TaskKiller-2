//
//  EditTagControlPanelVC.swift
//  TaskKiller
//
//  Created by mac on 15/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
class TagAddingControlsPanelVC: UIViewController, InfoForTagReporting, ColorChosenForTagReceiving, NameForTagReceiving {
    
    private var tagName: String!
    private var tagColor: UIColor = UIColor.gray
    
    //MARK: TagInfoReporting
    private weak var tagInfoReceiver: InfoForTagCreationReceiving!
    func setInfoForTagReceiver(_ receiver: InfoForTagCreationReceiving) {
        self.tagInfoReceiver = receiver
    }
    
    let opaqeAlpfa: CGFloat = 1
    let transparentAlpha: CGFloat = 0
    
    let doneEditingButtonAnimationTime: Double = 1
    let doneEditingButtonXPosition: CGFloat = 0.0
    
    let onScreenColorPaneMovementTime = 1.0
    let offScreenColorPaneMovementTime = 1.0
    
    @IBOutlet weak var addTag: UIButton!
    @IBOutlet weak var editTag: UIButton!
    
    @IBOutlet weak var creationControls: UIStackView!
    @IBOutlet weak var creationControlsLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var doneEditing: UIButton!
    @IBOutlet weak var doneEditingXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var colorPaineXPosition: NSLayoutConstraint!
    
    @IBOutlet weak var colorPaneCallButton: ColorPaneCallButton!
    
    
    //MARK: VC life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        moveCreationControlsOffScreen()
        moveAddAndEditButtonsOnScreen()
        moveDoneEditingButtonOffScreen()
        moveColorPaneOffScreen()
    }
    
    //MARK: Events
    @IBAction func addTagPressed() {
        moveAddAndEditButtonsOffScreen()
        moveCreationControlsOnScreen()
    }
    @IBAction func editTagButtonPressed() {
        moveAddAndEditButtonsOffScreen()
        moveDoneEditingButtonOnScreen()
    }
    @IBAction func doneTagCreationButtonPressed() {
        moveCreationControlsOffScreen()
        moveAddAndEditButtonsOnScreen()
        reportNewTagInfo()
    }
    
    @IBAction func doneEditingButtonPressed() {
        moveDoneEditingButtonOffScreen()
        moveAddAndEditButtonsOnScreen()
    }
    @IBAction func colorPaneCallButtonPressed() {
        moveCreationControlsOffScreen()
        moveColorPaneOnScreen()
    }
    
    @IBAction func cancelCreationWasPressed() {
        moveCreationControlsOffScreen()
        moveAddAndEditButtonsOnScreen()
    }
    
    //MARK: ChosenColorReceiving
    func colorForTagWasChosen(_ color: UIColor) {
        self.tagColor = color
        changeColorPaneCallButton(to: color)
        moveColorPaneOffScreen()
        moveCreationControlsOnScreen()
    }
    
    //MARK: TagNameReceiving
    func receiveNameForTag(_ name: String) {
        self.tagName = name
    }
    
    //MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Color Pane ChildVC":
            guard let chosenColorReporter = segue.destination as? ColorChosenForTagReporting else { fatalError() }
            chosenColorReporter.setColorChosenForTagReceiver(self)
        case "Child TagNameVC":
            guard let tagNameReporter = segue.destination as? NameForTagReporting else { fatalError() }
            tagNameReporter.setNameForTagReceiver(self)
        default: break
        }
    }
}
//MARK: AddButton, EditButton movements and animations
extension TagAddingControlsPanelVC {
    private func moveAddAndEditButtonsOffScreen() {
        moveAddBttonOffScreen()
        moveEditButtonOffScreen()
    }
    private func moveAddAndEditButtonsOnScreen() {
        moveAddButtonOnScreen()
        moveEditButtonOnScreen()
    }
    private func moveAddBttonOffScreen() {
        //fadeOut(view: addTag, withDuration: AnimationTimes.addButtonOffScreen)
        addTag.hide()
    }
    
    private func moveAddButtonOnScreen() {
       fadeIn(view: addTag, withDuration: AnimationTimes.addButtonOnScreen)
        addTag.show()
    }
    
    private func moveEditButtonOffScreen() {
        //fadeOut(view: editTag, withDuration: AnimationTimes.editButtonOffScreen)
        editTag.hide()
    }
    private func moveEditButtonOnScreen() {
        fadeIn(view: editTag, withDuration: AnimationTimes.editButtonOnScreen)
        editTag.show()
    }
    
    private func fadeOut(view: UIView, withDuration duration: Double) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self!.view.alpha = self!.transparentAlpha
        })
    }
    private func fadeIn(view: UIView, withDuration duration: Double) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self!.view.alpha = self!.opaqeAlpfa
        })
    }
}

//MARK: CreationControls movements and animations
extension TagAddingControlsPanelVC {
    private func moveCreationControlsOffScreen() {
        creationControlsLeadingConstraint.constant = 2 * view.bounds.width
        UIView.animate(withDuration: AnimationTimes.creationControlsOffScreen, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.view.layoutIfNeeded()
            self.creationControls.alpha = self.transparentAlpha
            }, completion: nil)
    }
    private func moveCreationControlsOnScreen() {
        creationControlsLeadingConstraint.constant = 5
        UIView.animate(withDuration: AnimationTimes.creationControlsOnScreen, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.view.layoutIfNeeded()
            self.creationControls.alpha = self.opaqeAlpfa
        }, completion: nil)
    }
}
//MARK: DoneEditingButton movements
extension TagAddingControlsPanelVC {
    private func moveDoneEditingButtonOffScreen() {
        UIView.animate(withDuration: AnimationTimes.doneEditingButtonOffScreen, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.doneEditing.alpha = self.transparentAlpha
            self.doneEditingXConstraint.constant = 2 * self.view.bounds.width
        }
        , completion: nil)
    }
    private func moveDoneEditingButtonOnScreen() {
        UIView.animate(withDuration: AnimationTimes.doneEditingButtonOnScreen, animations: { [weak self] in
            guard let self = self else { fatalError() }
            self.doneEditing.alpha = self.opaqeAlpfa
            self.doneEditingXConstraint.constant = self.doneEditingButtonXPosition
            }
            , completion: nil)
    }
}

//MARK: ColorPane movements
extension TagAddingControlsPanelVC {
    private func moveColorPaneOffScreen() {
        changeXPositionOfColorPaneToOffscreen()
        animateChangeOfConstraintWithDuration(AnimationTimes.colorPaneOffScreen)
    }
    private func moveColorPaneOnScreen() {
        changeXPositionOfColorPanelToOnScreen()
        animateChangeOfConstraintWithDuration(AnimationTimes.colorPaneOnScreen)
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

extension TagAddingControlsPanelVC {
    private func reportNewTagInfo() {
        tagInfoReceiver.receiveInfoForTagCreation(name: tagName, color: tagColor)
    }
    private func changeColorPaneCallButton(to color: UIColor) {
        colorPaneCallButton.setChosenColor(color)
    }
}

