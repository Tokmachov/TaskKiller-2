//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
import UIKit
import CoreData

class CreateTaskVC: UIViewController, InfoForTagReceiving, EditAndDeleteTagDropAreasDelegate, TagFromTaskRemovingDelegate, DropAreaForRemovingTagFromTaskPreparingDelegate, DeleteTagDelegate, EditTagDelegate {
    
    private var taskFactory: TaskFactory!
    private var tagFactory: TagFactory!
    
    private var layoutGuideForTagEditingArea: UILayoutGuide!
    private var tagEditingArea: TagEditingAreaView!
    private var deleteTagDropAreaVC: DeleteTagDropAreaVC!
    private var editTagDropAreaVC: EditTagDropAreaVC!
    private var dropAreaForRemovingTagFromTaskChildVC: DropAreaForRemovingTagFromTaskVC!
    
    private var tagsAddedToTaskVC: TagsForTaskPreparing!
    
    private var deleteTagDropAreaView: UIView!
    private var editDropAreaView: UIView!
    private var dropAreaForRemovingTagFromTaskView: UIView!
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
    private var yPositionConstraintOfTagEditingArea: NSLayoutConstraint!
    
    @IBOutlet weak var tagsCollectionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        taskFactory = TaskFactoryImp()
        tagFactory = TagFactoryImp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addTagEditingArea()
        
    }
    
    //MARK: InfoForTagReceiving
    func receiveInfoForTag(name: String, color: UIColor) {
        _ = tagFactory.createTag(from: name, and: color)
    }
    //MARK: EditAndDeleteTagDropAreasDelegate
    func prepareEditAndDeleteTagDropAreas() {
        addDeleteDropArea()
        addEditDropArea()
        moveTagEditingAreaOnScreen()
    }
    func editAndDeleteDropAreasNoLongerNeeded() {
        moveTagEditingAreaOffScreen()
        removeDeleteDropArea()
        removeEditDropArea()
    }
    //MARK: PrepareDropAreaForRemovingTagFromTaskDelegate
    func prepareDropAreaForRemovingTagFromTask() {
        addDropAreaForRemovingTagFromTask()
        moveTagEditingAreaOnScreen()
    }
    func dropAreaForRemovingTagFromTaskNoLongerNeeded() {
        removeDropAreaForRemovingTagFromTask()
        moveTagEditingAreaOffScreen()
    }
    //MARK: DeleteTagDelegate
    func needsToBeDeleted(_ tag: Tag) {
        tagFactory.deleteTagFromMemory(tag)
        tagsAddedToTaskVC.remove(tag)
    }
    //MARK: EditTagDelegate
    func performEditing(of tag: Tag) {
        let storeyBoard = UIStoryboard(name: "Main", bundle: nil)
        let editTagVC = storeyBoard.instantiateViewController(withIdentifier: "EditTagVC") as! EditTagVC
        editTagVC.setTagForEditing(tag)
        editTagVC.editTagCompletionDelegate = self
        present(editTagVC, animated: true, completion: nil)
    }
    func performCompletionOfEditing(for tag: Tag) {
        tagsAddedToTaskVC.wasUpdated(tag)
    }
    //MARK: TagFromTaskRemovingDelegate
    func removeTagFromTask(_ tag: Tag) {
        tagsAddedToTaskVC.remove(tag)
    }
    
    @IBAction func go(_ sender: UIButton) {
       performSegue(withIdentifier: "Start New Task", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "DeadLineChildVC":
            guard let deadLineVC = segue.destination as? DeadLineReporting else { fatalError() }
            deadLineVC.setDeadLineRerceiver(taskStaticInfoSource, deadLinesToChose: deadLinesTochose)
        case "TaskDescriptionChildVC":
            guard let taskDescriptionVC = segue.destination as? TaskDescriptionReporting else { fatalError() }
            taskDescriptionVC.setTaskDescriptionReceiver(taskStaticInfoSource)
        case "TagsAddedToTaskVC":
            guard let vc = segue.destination as? TagsForTaskPreparing else { fatalError() }
            tagsAddedToTaskVC = vc
            tagsAddedToTaskVC.setDelegate(self)
        case "TagsChildVC":
            guard let tagVC = segue.destination as? DragInitiatingVC else { fatalError() }
            tagVC.setDropAreaDelegate(self)
        case "EditTagControlPanelChildVC":
            guard let tagInfoReporter = segue.destination as? InfoForTagReporting else { fatalError() }
            tagInfoReporter.setInfoForTagReceiver(self)
        
        case "Start New Task":
            guard let taskVC = segue.destination as? TaskProgressTrackingVC else { fatalError() }
            let taskStaticInfo = taskStaticInfoSource.getStaticInfo()
            let task = taskFactory.createTask(from: taskStaticInfo)
            let tags = tagsAddedToTaskVC.getTagStore()
            task.addTags(tags)
            let progressTrackingTaskHandler = ProgressTrackingTaskHandlerImp(task: task)
            taskVC.setProgressTrackingTaskHandler(progressTrackingTaskHandler)
        
        default: break
        }
    }
}

extension CreateTaskVC {
    
    //MARK: addTagEditingArea
    private func addTagEditingArea() {
        createlayoutGuideForTagEditingArea()
        createTagEditingAreaRalativelyTo(layoutGuideForTagEditingArea)
    }
    private func createlayoutGuideForTagEditingArea() {
        layoutGuideForTagEditingArea = UILayoutGuide()
        view.addLayoutGuide(layoutGuideForTagEditingArea)
        layoutGuideForTagEditingArea.topAnchor.constraint(equalTo: tagsCollectionView.bottomAnchor).isActive = true
        layoutGuideForTagEditingArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        layoutGuideForTagEditingArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        layoutGuideForTagEditingArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
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
    
    //MARK: AddDeleteDropArea
    private func addDeleteDropArea() {
        addDeleteDropAreaChildVC()
        addDeleteDropAreaViewToTagEditingArea()
    }
    private func addDeleteDropAreaChildVC() {
        deleteTagDropAreaVC = DeleteTagDropAreaVC()
        deleteTagDropAreaVC.deleteTagDelegate = self
        addChildVC(deleteTagDropAreaVC)
    }
    private func addDeleteDropAreaViewToTagEditingArea() {
        deleteTagDropAreaView = deleteTagDropAreaVC.view!
        configureDeleteDropArea()
        addDropInteractionToDeleteDropArea()
        tagEditingArea.addDropArea(deleteTagDropAreaView)
    }
    private func configureDeleteDropArea() {
        deleteTagDropAreaView.backgroundColor = UIColor.blue
        deleteTagDropAreaView.translatesAutoresizingMaskIntoConstraints = false
        deleteTagDropAreaView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        deleteTagDropAreaView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    private func addDropInteractionToDeleteDropArea() {
        let dropInteration = UIDropInteraction(delegate: deleteTagDropAreaVC)
        deleteTagDropAreaView.addInteraction(dropInteration)
    }
    
    //MARK: remveDeleteDropArea
    private func removeDeleteDropArea() {
        removeDeleteDropAreaChildVC()
        removeDeleteDropAreaFromTagEditingArea()
    }
    private func removeDeleteDropAreaChildVC() {
        self.removeChildVC(deleteTagDropAreaVC)
        deleteTagDropAreaVC = nil
    }
    private func removeDeleteDropAreaFromTagEditingArea() {
        tagEditingArea.removeDropArea(deleteTagDropAreaView)
    }
    
    //MARK: addEditDropArea
    private func addEditDropArea() {
        addEditDropAreaChildVC()
        addEditDropAreaViewToTagEditingArea()
    }
    private func addEditDropAreaChildVC() {
        editTagDropAreaVC = EditTagDropAreaVC()
        editTagDropAreaVC.editTagPerformingDelegate = self
        addChildVC(editTagDropAreaVC)
    }
    private func addEditDropAreaViewToTagEditingArea() {
        editDropAreaView = editTagDropAreaVC.view!
        configureEditDropArea()
        addDropInteractionToEditDropArea()
        tagEditingArea.addDropArea(editDropAreaView)
    }
    private func configureEditDropArea() {
        editDropAreaView.backgroundColor = UIColor.red
        editDropAreaView.translatesAutoresizingMaskIntoConstraints = false
        editDropAreaView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        editDropAreaView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    private func addDropInteractionToEditDropArea() {
        let dropInteraction = UIDropInteraction(delegate: editTagDropAreaVC)
        editDropAreaView.addInteraction(dropInteraction)
    }
    
    //MARK: removeEditDropArea
    private func removeEditDropArea() {
        removeEditDropAreaChildVC()
        removeEditDropAreaViewFromTagEditingArea()
    }
    private func removeEditDropAreaChildVC() {
        self.removeChildVC(editTagDropAreaVC)
        editTagDropAreaVC = nil
    }
    private func removeEditDropAreaViewFromTagEditingArea() {
        tagEditingArea.removeDropArea(editDropAreaView)
    }
    
    //MAR: addDropAreaForRemovingTagFromTask()
    private func addDropAreaForRemovingTagFromTask() {
        addDropAreaForRemovingTagFromTaskChildVC()
        addDropAreaForRemovingTagFromTaskView()
    }
    private func addDropAreaForRemovingTagFromTaskChildVC() {
        dropAreaForRemovingTagFromTaskChildVC = DropAreaForRemovingTagFromTaskVC()
        dropAreaForRemovingTagFromTaskChildVC.setTagFromTaskRemovingDelegate(self)
        self.addChildVC(dropAreaForRemovingTagFromTaskChildVC)
    }
    private func addDropAreaForRemovingTagFromTaskView() {
        dropAreaForRemovingTagFromTaskView = dropAreaForRemovingTagFromTaskChildVC.view!
        configureDropAreaForRemovingTagFromTaskView()
        addDropInteractionToDropAreaForRemovingTagFromTask()
        tagEditingArea.addDropArea(dropAreaForRemovingTagFromTaskView)
    }
    private func configureDropAreaForRemovingTagFromTaskView() {
        dropAreaForRemovingTagFromTaskView.backgroundColor = UIColor.yellow
        dropAreaForRemovingTagFromTaskView.translatesAutoresizingMaskIntoConstraints = false
        dropAreaForRemovingTagFromTaskView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        dropAreaForRemovingTagFromTaskView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    private func addDropInteractionToDropAreaForRemovingTagFromTask() {
        let dropInteration = UIDropInteraction(delegate: dropAreaForRemovingTagFromTaskChildVC)
        dropAreaForRemovingTagFromTaskView.addInteraction(dropInteration)
    }
    
    //MARK: removeDropAreaForRemovingTagFromTask()
    private func removeDropAreaForRemovingTagFromTask() {
        removeDropAreaForRemovingTagFromTaskChildVC()
        removeDropAreaForRemovingTagFromTaskView()
    }
    private func removeDropAreaForRemovingTagFromTaskChildVC() {
        self.removeChildVC(dropAreaForRemovingTagFromTaskChildVC)
        dropAreaForRemovingTagFromTaskChildVC = nil
    }
    private func removeDropAreaForRemovingTagFromTaskView() {
        tagEditingArea.removeDropArea(dropAreaForRemovingTagFromTaskView)
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
