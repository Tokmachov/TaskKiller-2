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
   
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
    
    
    private var tagEditingArea: TagEditingAreaView!
    private var yPositionConstraintOfTagEditingArea: NSLayoutConstraint!
    
    private var deleteTagArea: UIView!
    private var editTagArea: UIView!
    private var addToTaskTagArea: UIView!
    
    @IBOutlet weak var tagsCollectionView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTagEditingArea()
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
    private func addTagEditingArea() {
        let layoutGuideForTagEditingArea = createlayoutGuideForTagEditingArea()
        let tagEditingArea = createTagEditingAreaRalativelyTo(layoutGuideForTagEditingArea)
        let stack = createStackForDropAreasPositioning()
        tagEditingArea.addSubview(stack)
        positionStackInsideTagEditingArea(stack)
        let deleteTagDropAreaVC = DeleteTagDropAreaVC()
        addChildVC(deleteTagDropAreaVC)
        deleteTagDropAreaVC.view = createDeleteTagDropAreaRelativelyTo(layoutGuideForTagEditingArea)
        let dropInteration = UIDropInteraction(delegate: deleteTagDropAreaVC)
        deleteTagDropAreaVC.view.addInteraction(dropInteration)
        stack.addArrangedSubview(deleteTagDropAreaVC.view)
        
//        editTagArea = createEditTagViewRelativelyTo(layoutGuideForTagEditingArea)
//        stack.addArrangedSubview(editTagArea)
//        addToTaskTagArea = createAddToTaskTagViewRelativelyTo(layoutGuideForTagEditingArea)
//        stack.addArrangedSubview(addToTaskTagArea)
        view.layoutIfNeeded()
        
    }
    
    private func createlayoutGuideForTagEditingArea() -> UILayoutGuide {
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)
        guide.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor).isActive = true
        guide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        guide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        guide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        return guide
    }
    
    private func createTagEditingAreaRalativelyTo(_ layoutGuide: UILayoutGuide) -> TagEditingAreaView {
        let tagEditingArea = TagEditingAreaView()
        tagEditingArea.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        view.addSubview(tagEditingArea)
        tagEditingArea.translatesAutoresizingMaskIntoConstraints = false
        tagEditingArea.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1).isActive = true
        tagEditingArea.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 1).isActive = true
        tagEditingArea.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        yPositionConstraintOfTagEditingArea = tagEditingArea.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: layoutGuide.layoutFrame.height)
        yPositionConstraintOfTagEditingArea.isActive = true
        return tagEditingArea
    }
    private func createStackForDropAreasPositioning() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
        return stack
    }
    private func positionStackInsideTagEditingArea(_ stack: UIStackView) {
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: stack.superview!.centerXAnchor, constant: 0).isActive = true
        stack.centerYAnchor.constraint(equalTo: stack.superview!.centerYAnchor, constant: 0).isActive = true
    }
    
    private func createDeleteTagDropAreaRelativelyTo(_ layoutGuide: UILayoutGuide) -> UIView {
        let view = UIView()
        self.view.addSubview(view)
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 0.25).isActive = true
        view.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        return view
    }
    
//    private func createEditTagViewRelativelyTo(_ layoutGuide: UILayoutGuide) -> UIView {
//        let view = UIView()
//        view.backgroundColor = UIColor.red
//        tagEditingArea.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 0.25).isActive = true
//        view.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 0.25).isActive = true
//        return view
//    }
//    private func createAddToTaskTagViewRelativelyTo(_ layoutGuide: UILayoutGuide) -> UIView {
//        let view = UIView()
//        view.backgroundColor = UIColor.white
//        tagEditingArea.addSubview(view)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 0.25).isActive = true
//        view.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 0.25).isActive = true
//        return view
//    }
//
    
    
 
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
