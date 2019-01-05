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

class CreateTaskVC: UIViewController, InfoForTagReceiving {
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
    private var tagEditingArea: TagEditingArea!
    private var yPositionConstraintOfTagEditingArea: NSLayoutConstraint!
    private let tagEditingAreaMovementTime: CGFloat = 0.5
    
    @IBOutlet weak var tagsCollectionView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addTagEditingArea()
        //moveTagEditingAreaOffScreen()
        //moveTagEditingAreaOnScreen()
    }
    @IBAction func go(_ sender: UIButton) {
       performSegue(withIdentifier: "Start New Task", sender: nil)
    }
    func receiveInfoForTag(name: String, color: UIColor) {
        _ = TagFactoryImp.createTag(from: name, and: color)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "TaskDescriptionChildVC":
            guard let taskDescriptionVC = segue.destination as? TaskDescriptionReporting else { fatalError() }
            taskDescriptionVC.setTaskDescriptionReceiver(taskStaticInfoSource)
        case "DeadLineChildVC":
            guard let deadLineVC = segue.destination as? DeadLineReporting else { fatalError() }
            deadLineVC.setDeadLineRerceiver(taskStaticInfoSource, deadLinesToChose: deadLinesTochose)
//        case "TagsChildVC":
//            guard let tagsVC = segue.destination as? TagsReporting else { fatalError() }
//            tagsVC.setTagsReceiver(taskStaticInfoSource)
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
        let frame = getFrameForTagEditingArea()
        tagEditingArea = createTagEditingAreaWithFrame(frame)
        addTagEditingAreaToSuperview()
        constraintTagEditingArea()
    }
    // addTagEditingArea.1
    private func getFrameForTagEditingArea() -> CGRect {
        let guide = createlayoutGuideForAreaBelowTagsCollectionView()
        return guide.layoutFrame
    }
    // addTagEditingArea.1.1
    private func createlayoutGuideForAreaBelowTagsCollectionView() -> UILayoutGuide {
        let guide = UILayoutGuide()
        view.addLayoutGuide(guide)
        guide.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor).isActive = true
        guide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        guide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        guide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        return guide
    }
    
    // addTagEditingArea.2
    private func createTagEditingAreaWithFrame(_ frame: CGRect) -> TagEditingArea {
        return TagEditingArea(frame: frame)
    }
    // addTagEditingArea.3
    private func addTagEditingAreaToSuperview() {
        view.addSubview(tagEditingArea)
    }
    // addTagEditingArea.4
    private func constraintTagEditingArea() {
        let widthOfTagEditingArea = tagEditingArea.frame.width
        let heightOfTagEditingArea = tagEditingArea.frame.height
        
        tagEditingArea.translatesAutoresizingMaskIntoConstraints = false
        tagEditingArea.widthAnchor.constraint(equalToConstant: widthOfTagEditingArea).isActive = true
        tagEditingArea.heightAnchor.constraint(equalToConstant: heightOfTagEditingArea).isActive = true
        tagEditingArea.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        yPositionConstraintOfTagEditingArea = tagEditingArea.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor, constant: heightOfTagEditingArea)
        yPositionConstraintOfTagEditingArea.isActive = true
    }
    //MARK: removeTagEditingArea
    private func removeTagEditingArea() {
        tagEditingArea.removeFromSuperview()
    }
    
    //MARK: moveTagEditingArea
    private func moveTagEditingAreaOffScreen() {
        yPositionConstraintOfTagEditingArea.constant = tagEditingArea.getHeight()
        UIView.animate(withDuration: AnimationTimes.tagEditingPanelOffScreen, animations: { [weak self] in
            self!.view.layoutIfNeeded()
        }, completion: nil)
    }
    private func moveTagEditingAreaOnScreen() {
        yPositionConstraintOfTagEditingArea.constant = 0.0
        UIView.animate(withDuration: AnimationTimes.tagEditingPanelOnScreen , animations: { [weak self] in
            self!.view.layoutIfNeeded()
        }, completion: nil)
    }

}
