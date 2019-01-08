//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class CreateTaskVC: UIViewController, InfoForTagReceiving, DropAreaDelegate {
   
    private var layoutGuideForTagEditingArea: UILayoutGuide!
    private var tagEditingArea: TagEditingAreaView!
    private var deleteTagDropAreaVC: DeleteTagDropAreaVC!
    private var editDropAreaVC: EditTagDropAreaVC!
    
    private var deleteTagDropAreaView: UIView!
    private var editDropAreaView: UIView!
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
    private var yPositionConstraintOfTagEditingArea: NSLayoutConstraint!
    
    @IBOutlet weak var tagsCollectionView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTagEditingArea()
        addDeleteDropAreaChildVC()
        addDeleteDropAreaToTagEditingArea()
        addEditDropAreaChildVC()
        addEditDropAreaToTagEditingArea()
    }
    
    //MARK: InfoForTagReceiving
    func receiveInfoForTag(name: String, color: UIColor) {
        _ = TagFactoryImp.createTag(from: name, and: color)
    }
    //MARK: DropAreaDelegate
    func prepareDropArea() {
        moveTagEditingAreaOnScreen()
    }
    func dropAreaIsNoLongerNeeded() {
        moveTagEditingAreaOffScreen()
    }
    
    @IBAction func go(_ sender: UIButton) {
       performSegue(withIdentifier: "Start New Task", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "TaskDescriptionChildVC":
            guard let taskDescriptionVC = segue.destination as? TaskDescriptionReporting else { fatalError() }
            taskDescriptionVC.setTaskDescriptionReceiver(taskStaticInfoSource)
        case "DeadLineChildVC":
            guard let deadLineVC = segue.destination as? DeadLineReporting else { fatalError() }
            deadLineVC.setDeadLineRerceiver(taskStaticInfoSource, deadLinesToChose: deadLinesTochose)
        case "TagsChildVC":
            guard let tagVC = segue.destination as? DragInitiatingVC else { fatalError() }
            tagVC.setDropAreaDelegate(self)
        case "EditTagControlPanelChildVC":
            guard let tagInfoReporter = segue.destination as? InfoForTagReporting else { fatalError() }
            tagInfoReporter.setInfoForTagReceiver(self)
        
        case "Start New Task":
            guard let taskVC = segue.destination as? TaskProgressTrackingVC else { fatalError() }
            let taskStaticInfo = taskStaticInfoSource.getStaticInfo()
            let task = TaskFactoryImp.createTask(from: taskStaticInfo)
            let progressTrackingTaskHandler = ProgressTrackingTaskHandlerImp(task: task)
            taskVC.setProgressTrackingTaskHandler(progressTrackingTaskHandler)
        
        default: break
        }
    }
}

extension CreateTaskVC {
    //MARK: addTagEditingArea
    // 1
    private func addTagEditingArea() {
        createlayoutGuideForTagEditingArea()
        createTagEditingAreaRalativelyTo(layoutGuideForTagEditingArea)
    }
    // 1.1
    private func createlayoutGuideForTagEditingArea() {
        layoutGuideForTagEditingArea = UILayoutGuide()
        view.addLayoutGuide(layoutGuideForTagEditingArea)
        layoutGuideForTagEditingArea.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor).isActive = true
        layoutGuideForTagEditingArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        layoutGuideForTagEditingArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        layoutGuideForTagEditingArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    // 1.2
    private func createTagEditingAreaRalativelyTo(_ layoutGuide: UILayoutGuide) {
        tagEditingArea = TagEditingAreaView()
        tagEditingArea.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        view.addSubview(tagEditingArea)
        tagEditingArea.translatesAutoresizingMaskIntoConstraints = false
        tagEditingArea.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1).isActive = true
        tagEditingArea.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 1).isActive = true
        tagEditingArea.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        yPositionConstraintOfTagEditingArea = tagEditingArea.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: layoutGuide.layoutFrame.height)
        yPositionConstraintOfTagEditingArea.isActive = true
    }
    // 2
    private func addDeleteDropAreaChildVC() {
        deleteTagDropAreaVC = DeleteTagDropAreaVC()
        addChildVC(deleteTagDropAreaVC)
    }
    // 3
    private func addDeleteDropAreaToTagEditingArea() {
        deleteTagDropAreaView = deleteTagDropAreaVC.view!
        configureDeleteDropArea()
        addDropInteractionToDeleteDropArea()
        tagEditingArea.addDropArea(deleteTagDropAreaView)
    }
    // 3.1
    private func configureDeleteDropArea() {
        deleteTagDropAreaView.backgroundColor = UIColor.blue
        deleteTagDropAreaView.translatesAutoresizingMaskIntoConstraints = false
        deleteTagDropAreaView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        deleteTagDropAreaView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    // 3.2
    private func addDropInteractionToDeleteDropArea() {
        let dropInteration = UIDropInteraction(delegate: deleteTagDropAreaVC)
        deleteTagDropAreaView.addInteraction(dropInteration)
    }
    // 4
    private func addEditDropAreaChildVC() {
        editDropAreaVC = EditTagDropAreaVC()
        addChildVC(editDropAreaVC)
    }
    // 5
    private func addEditDropAreaToTagEditingArea() {
        editDropAreaView = editDropAreaVC.view!
        configureEditDropArea()
        addDropInteractionToEditDropArea()
        tagEditingArea.addDropArea(editDropAreaView)
    }
    // 5.1
    private func configureEditDropArea() {
        editDropAreaView.backgroundColor = UIColor.red
        editDropAreaView.translatesAutoresizingMaskIntoConstraints = false
        editDropAreaView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        editDropAreaView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    // 5.2
    private func addDropInteractionToEditDropArea() {
        let dropInteraction = UIDropInteraction(delegate: editDropAreaVC)
        editDropAreaView.addInteraction(dropInteraction)
    }
    
    //MARK: removeTagEditingArea
    private func removeTagEditingArea() {
        tagEditingArea.removeFromSuperview()
        view.layoutIfNeeded()
    }
    
    //MARK: moveTagEditingArea
    private func moveTagEditingAreaOffScreen() {
        yPositionConstraintOfTagEditingArea.constant = self.view.getHeight()
        animateChangeOfConstraintWithDuration(AnimationTimes.tagEditingPanelOffScreen)
    }
    private func moveTagEditingAreaOnScreen() {
        yPositionConstraintOfTagEditingArea.constant = 0.0
        animateChangeOfConstraintWithDuration(AnimationTimes.tagEditingPanelOnScreen)
    }
    
    private func animateChangeOfConstraintWithDuration(_ duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self!.view.layoutIfNeeded()
            }, completion: nil)
    }
}
