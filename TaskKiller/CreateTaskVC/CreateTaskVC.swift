//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
import UIKit
import CoreData

class CreateTaskVC: UIViewController, InfoForTagCreationReceiving, TagEditingAndDeletingFromAllTagsDropAreasPreparingDelegate, TagFromTaskRemovingDelegate, TagRemovingFromTaskDropAreaPreparingDelegate, TagFromAllTagsDeletingDelegate, TagEditingDelegate {
    
    //MARK: Model
    private var taskFactory: TaskFactory!
    private var tagFactory: TagFactory!
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    
    //MARK: TagEditingAreaView
    private var tagEditingAreaView: TagEditingAreaView!
    private var layoutGuideForTagEditingArea: UILayoutGuide!
    private var yPositionConstraintOfTagEditingAreaView: NSLayoutConstraint!
    
    //MARK: DropAreas VCs
    private var tagDeletingFromAllTagsDropAreaVC: TagDeletingFromAllTagsDropAreaVC!
    private var tagDeletingFromAllTagsDropAreaView: UIView!
    private var tagEditingDropAreaVC: TagEditingDropAreaVC!
    private var tagEditingDropAreaView: UIView!
    private var tagRemovingFromTaskDropAreaVC: TagRemovingFromTaskDropAreaVC!
    private var tagRemovingFromTaskView: UIView!
    
    //MARK: TagsAddedToTask VC
    private var tagsAddedToTaskVC: TagsForTaskPreparing!
    
    //MARK: TaskStaticInfo controller
    private var taskStaticInfoController = TaskStaticInfoController()
    
    @IBOutlet weak var allTagsCollectionView: UIView!
    
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
    func receiveInfoForTagCreation(name: String, color: UIColor) {
        _ = tagFactory.createTag(from: name, and: color)
    }
    //MARK: EditAndDeleteTagDropAreasDelegate
    func prepareTagEditingAndDeletingFromAllTagsDropAreas() {
        addTagDeletingFromAllTagsDropArea()
        addTagEditingDropArea()
        moveTagEditingAreaOnScreen()
    }
    func removeTagEditingAndDeletingFromAllDropAreas() {
        moveTagEditingAreaViewOffScreen()
        removeTagDeletingFromAllTagsDropArea()
        removeTagEditingDropArea()
    }
    //MARK: PrepareDropAreaForRemovingTagFromTaskDelegate
    func prepareTagRemovingFromAllTaskDropArea() {
        addTagRemovingFromTaskDropArea()
        moveTagEditingAreaOnScreen()
    }
    func removeTagRemovingFromAllTagsDropArea() {
        removeTagRemovingFromTaskDropAreaView()
        moveTagEditingAreaViewOffScreen()
    }
    //MARK: DeleteTagDelegate
    func performDeletingFromAllTags(of tag: Tag) {
        tagFactory.deleteTagFromMemory(tag)
        tagsAddedToTaskVC.removeFromTask(tag)
    }
    //MARK: EditTagDelegate
    func performEditing(of tag: Tag) {
        let storeyBoard = UIStoryboard(name: "Main", bundle: nil)
        let editTagVC = storeyBoard.instantiateViewController(withIdentifier: "EditTagVC") as! TagEditingVC
        editTagVC.setTagForEditing(tag)
        editTagVC.editTagCompletionDelegate = self
        present(editTagVC, animated: true, completion: nil)
    }
    func performCompletionOfEditing(for tag: Tag) {
        tagsAddedToTaskVC.tagAddedToTaskWasUpdated(tag)
    }
    //MARK: TagFromTaskRemovingDelegate
    func performRemovingTask(of tag: Tag) {
        tagsAddedToTaskVC.removeFromTask(tag)
    }
    
    @IBAction func go(_ sender: UIButton) {
       performSegue(withIdentifier: "Start New Task", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "DeadLineChildVC":
            guard let deadLineVC = segue.destination as? DeadLineReporting else { fatalError() }
            deadLineVC.setDeadLineRerceiver(taskStaticInfoController, deadLinesToChose: deadLinesTochose)
        case "TaskDescriptionChildVC":
            guard let taskDescriptionVC = segue.destination as? TaskDescriptionReporting else { fatalError() }
            taskDescriptionVC.setTaskDescriptionReceiver(taskStaticInfoController)
        case "TagsAddedToTaskVC":
            guard let vc = segue.destination as? TagsForTaskPreparing else { fatalError() }
            tagsAddedToTaskVC = vc
            tagsAddedToTaskVC.setDelegate(self)
        case "TagsChildVC":
            guard let tagVC = segue.destination as? DragInitiatingVC else { fatalError() }
            tagVC.setDropAreaPreparingDelegate(self)
        case "EditTagControlPanelChildVC":
            guard let tagInfoReporter = segue.destination as? InfoForTagReporting else { fatalError() }
            tagInfoReporter.setInfoForTagReceiver(self)
        
        case "Start New Task":
            guard let taskVC = segue.destination as? TaskProgressTrackingVC else { fatalError() }
            let taskStaticInfo = taskStaticInfoController.getStaticInfo()
            let task = taskFactory.createTask(from: taskStaticInfo)
            let tags = tagsAddedToTaskVC.getTagsAddedToTaskStore()
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
        layoutGuideForTagEditingArea.topAnchor.constraint(equalTo: allTagsCollectionView.bottomAnchor).isActive = true
        layoutGuideForTagEditingArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        layoutGuideForTagEditingArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        layoutGuideForTagEditingArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    private func createTagEditingAreaRalativelyTo(_ layoutGuide: UILayoutGuide) {
        tagEditingAreaView = TagEditingAreaView()
        tagEditingAreaView.backgroundColor = UIColor.green.withAlphaComponent(0.5)
        view.addSubview(tagEditingAreaView)
        tagEditingAreaView.translatesAutoresizingMaskIntoConstraints = false
        tagEditingAreaView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1).isActive = true
        tagEditingAreaView.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 1).isActive = true
        tagEditingAreaView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        yPositionConstraintOfTagEditingAreaView = tagEditingAreaView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: layoutGuide.layoutFrame.height)
        yPositionConstraintOfTagEditingAreaView.isActive = true
    }
    
    //MARK: addTagDeletingFromAllTagsDropArea
    private func addTagDeletingFromAllTagsDropArea() {
        addTagDeletingFromAllTagsDropAreaVC()
        addTagDeletingFromAllTagsDropAreaViewToTagEditingArea()
    }
    private func addTagDeletingFromAllTagsDropAreaVC() {
        tagDeletingFromAllTagsDropAreaVC = tagDeletingFromAllTagsDropAreaVC()
        tagDeletingFromAllTagsDropAreaVC.deleteTagDelegate = self
        addChildVC(tagDeletingFromAllTagsDropAreaVC)
    }
    private func addTagDeletingFromAllTagsDropAreaViewToTagEditingArea() {
        tagDeletingFromAllTagsDropAreaView = tagDeletingFromAllTagsDropAreaVC.view!
        configureTagDeletingFromAllTagsDropAreaView()
        addDropInteractionToTagDeletingFromAllTagsDropAreaView()
        tagEditingAreaView.addDropArea(tagDeletingFromAllTagsDropAreaView)
    }
    private func configureTagDeletingFromAllTagsDropAreaView() {
        tagDeletingFromAllTagsDropAreaView.backgroundColor = UIColor.blue
        tagDeletingFromAllTagsDropAreaView.translatesAutoresizingMaskIntoConstraints = false
        tagDeletingFromAllTagsDropAreaView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        tagDeletingFromAllTagsDropAreaView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    private func addDropInteractionToTagDeletingFromAllTagsDropAreaView() {
        let dropInteration = UIDropInteraction(delegate: tagDeletingFromAllTagsDropAreaVC)
        tagDeletingFromAllTagsDropAreaView.addInteraction(dropInteration)
    }
    
    //MARK: removeTagDeletingFromAllTagsDropArea
    private func removeTagDeletingFromAllTagsDropArea() {
        removeTagDeletingFromAllTagsDropAreaVC()
        removeTagDeletingFromAllTagsDropAreaViewFromTagEditingAreaView()
    }
    private func removeTagDeletingFromAllTagsDropAreaVC() {
        self.removeChildVC(tagDeletingFromAllTagsDropAreaVC)
        tagDeletingFromAllTagsDropAreaVC = nil
    }
    private func removeTagDeletingFromAllTagsDropAreaViewFromTagEditingAreaView() {
        tagEditingAreaView.removeDropArea(tagDeletingFromAllTagsDropAreaView)
    }
    
    //MARK: addTagEditingDropArea
    private func addTagEditingDropArea() {
        addTagEditingDropAreaVC()
        addTagEditingDropAreaViewToTagEditingAreaView()
    }
    private func addTagEditingDropAreaVC() {
        tagEditingDropAreaVC = TagEditingDropAreaVC()
        tagEditingDropAreaVC.editTagPerformingDelegate = self
        addChildVC(tagEditingDropAreaVC)
    }
    private func addTagEditingDropAreaViewToTagEditingAreaView() {
        tagEditingDropAreaView = tagEditingDropAreaVC.view!
        configureTagEditingDropAreaView()
        addDropInteractionToTagEditingDropAreaView()
        tagEditingAreaView.addDropArea(tagEditingDropAreaView)
    }
    private func configureTagEditingDropAreaView() {
        tagEditingDropAreaView.backgroundColor = UIColor.red
        tagEditingDropAreaView.translatesAutoresizingMaskIntoConstraints = false
        tagEditingDropAreaView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        tagEditingDropAreaView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    private func addDropInteractionToTagEditingDropAreaView() {
        let dropInteraction = UIDropInteraction(delegate: tagEditingDropAreaVC)
        tagEditingDropAreaView.addInteraction(dropInteraction)
    }
    
    //MARK: removeTagEditingDropArea
    private func removeTagEditingDropArea() {
        removeTagEditingDropAreaVC()
        removeTagEditingDropAreaViewFromTagEditingAreaView()
    }
    private func removeTagEditingDropAreaVC() {
        self.removeChildVC(tagEditingDropAreaVC)
        tagEditingDropAreaVC = nil
    }
    private func removeTagEditingDropAreaViewFromTagEditingAreaView() {
        tagEditingAreaView.removeDropArea(tagEditingDropAreaView)
    }
    
    //MAR: addDropAreaForRemovingTagFromTask()
    private func addTagRemovingFromTaskDropArea() {
        addTagRemovingFromTaskDropAreaVC()
        addTagRemovingFromTaskDropAreaView()
    }
    private func addTagRemovingFromTaskDropAreaVC() {
        tagRemovingFromTaskDropAreaVC = TagRemovingFromTaskDropAreaVC()
        tagRemovingFromTaskDropAreaVC.setTagFromTaskRemovalPerfomingDelegate(self)
        self.addChildVC(tagRemovingFromTaskDropAreaVC)
    }
    private func addTagRemovingFromTaskDropAreaView() {
        tagRemovingFromTaskView = tagRemovingFromTaskDropAreaVC.view!
        configureTagRemovingFromTaskDropAreaView()
        addDropInteractionToTagRemovingFromTaskDropAreaView()
        tagEditingAreaView.addDropArea(tagRemovingFromTaskView)
    }
    private func configureTagRemovingFromTaskDropAreaView() {
        tagRemovingFromTaskView.backgroundColor = UIColor.yellow
        tagRemovingFromTaskView.translatesAutoresizingMaskIntoConstraints = false
        tagRemovingFromTaskView.widthAnchor.constraint(equalTo: layoutGuideForTagEditingArea.widthAnchor, multiplier: 0.25).isActive = true
        tagRemovingFromTaskView.heightAnchor.constraint(equalTo: layoutGuideForTagEditingArea.heightAnchor, multiplier: 0.25).isActive = true
    }
    private func addDropInteractionToTagRemovingFromTaskDropAreaView() {
        let dropInteration = UIDropInteraction(delegate: tagRemovingFromTaskDropAreaVC)
        tagRemovingFromTaskView.addInteraction(dropInteration)
    }
    
    //MARK: removeTagRemovingFromTaskDropAreaView()
    private func removeTagRemovingFromTaskDropAreaView() {
        removeTagRemovingFromTaskDropAreaVC()
        removeTagRemovingFromTaskDropAreaView()
    }
    private func removeTagRemovingFromTaskDropAreaVC() {
        self.removeChildVC(tagRemovingFromTaskDropAreaVC)
        tagRemovingFromTaskDropAreaVC = nil
    }
    private func removeTagRemovingFromTaskDropAreaView() {
        tagEditingAreaView.removeDropArea(tagRemovingFromTaskView)
    }
    
    //MARK: removeTagEditingArea
    private func removeTagEditingAreaView() {
        tagEditingAreaView.removeFromSuperview()
        view.layoutIfNeeded()
    }
    
    //MARK: moveTagEditingAreaViewOffScreen
    private func moveTagEditingAreaViewOffScreen() {
        yPositionConstraintOfTagEditingAreaView.constant = self.view.getHeight()
        animateChangeOfConstraintWithDuration(AnimationTimes.tagEditingPanelOffScreen)
    }
    private func moveTagEditingAreaOnScreen() {
        yPositionConstraintOfTagEditingAreaView.constant = 0.0
        animateChangeOfConstraintWithDuration(AnimationTimes.tagEditingPanelOnScreen)
    }
    
    private func animateChangeOfConstraintWithDuration(_ duration: Double) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            self!.view.layoutIfNeeded()
            }, completion: nil)
    }
}
