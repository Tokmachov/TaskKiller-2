//
//  CreateTaskVC2.swift
//  TaskKiller
//
//  Created by mac on 23/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
class CreateTaskVC: UITableViewController,
    TaskDescriptionVCDelegate,
    DeadlineVCDelegate,
    CreateTagVCDelegate,
    AvailableTagsVCDelegate,
    DeleteTagDropAreaVCDelegate,
    EditTagDropAreaVCDelegate,
    EditTagVCDelegate,
    TagsAddedToTaskVCDelegate,
    RemoveTagFromTaskVCDelegate
{
  
    private lazy var tagFactory = TagFactoryImp()
    private lazy var taskFactory = TaskFactoryImp(tagFactory: tagFactory)
    
    //MARK: Model
    private var taskDescription: String? {
        didSet { updateGoButtonEnability() }
    }
    private var deadline: TimeInterval? {
        didSet { updateGoButtonEnability() }
    }
    private var tagsAddedToTask: ImmutableTagStore? {
        didSet { updateGoButtonEnability() }
    }
    
    private var isGoButtonEnabled: Bool {
        let isTaskDescriptionValid: Bool = {
            if let description = taskDescription, !description.isEmpty { return true }
                return false
        }()
        let isDeadlineValid: Bool = deadline != nil
        let areTagsAddedToTaskValid: Bool =  {
            if tagsAddedToTask != nil, !tagsAddedToTask!.tags.isEmpty { return true }
            return false
        }()
        return isTaskDescriptionValid && isDeadlineValid && areTagsAddedToTaskValid
    }
    
    //MARK: Views
    @IBOutlet weak var deadlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropAreasHeight: NSLayoutConstraint!
    private let foldedDropAreasCellHeight: CGFloat = 0
    @IBOutlet weak var dropAreaViewForTagDeleting: UIView!
    @IBOutlet weak var dropAreaViewForRemovingTagFromTask: UIView!
    @IBOutlet weak var dropAreaViewForTagEditing: UIView!
    @IBOutlet weak var goButton: UIBarButtonItem!
    
    private weak var tagsAddedToTaskVC: TagsAddedToTaskVC!
    @IBOutlet weak var tagsAddedToTaskHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var q: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideDropAreaForTagDeleingAndEditing()
        hideDropAreaForRemovingOfTagFromTask()
        foldDropAreasRow(andThen: {})
        updateGoButtonEnability()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TaskDescriptionVC":
            let vc = segue.destination as! TaskDescriptionVC
            vc.delegate = self
        case "DeadlineVC":
            let vc = segue.destination as! DeadlineVC
            vc.delegate = self
            addChild(vc)
        case "CreateTagVC":
            let vc = (segue.destination as? UINavigationController)?.viewControllers.first as! CreateTagVC
            vc.delegate = self
        case "AvailableTagsVC":
            let vc = segue.destination as! AvailableTagsVC
            vc.delegate = self
        case "DeleteTagDropAreaVC":
            let vc = segue.destination as! DeleteTagDropAreaVC
            vc.delegate = self
        case "EditTagDropAreaVC":
            let vc = segue.destination as! EditTagDropAreaVC
            vc.delegate = self
        case "TagsAddedToTaskVC":
            let vc = segue.destination as! TagsAddedToTaskVC
            vc.delegate = self
            tagsAddedToTaskVC = vc
        case "RemoveTagFromTaskVC":
            let vc = segue.destination as! RemoveTagFromTaskDropAreaVC
            vc.delegate = self 
        case "StartNewTask":
            guard let taskVC = segue.destination as? TaskProgressTrackingVC else { fatalError() }
            print("before creating \(tagsAddedToTaskVC.tagsAddedToTaskStore.tagsCount)")
            let taskStaticInfo = TaskStaticInfo(taskDescription: taskDescription!,
                                                initialDeadLine: deadline!,
                                                tags: tagsAddedToTaskVC.tagsAddedToTaskStore
            )
            let task = taskFactory.makeTask(taskStaticInfo: taskStaticInfo)
            let progressTrackingTaskHandler = TaskProgressSavingModelImp(task: task)
            taskVC.setProgressTrackingTaskHandler(progressTrackingTaskHandler)
        default: break
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Delegates
    func taskDescriptionVC(_ taskDescriptionVC: TaskDescriptionVC, didEnterDescription taskDescription: String) {
        self.taskDescription = taskDescription
    }
    
    func deadlineVC(_ deadlineVC: DeadlineVC, didChooseDeadline deadline: TimeInterval) {
        self.deadline = deadline
    }
    
    func createTagVC(_ createTagVC: CreateTagVC, didChooseName name: String, AndColor color: UIColor) {
        _ = tagFactory.makeTag(name: name, color: color)
    }
    
    func availableTagsVCDidBegingDrag(_ availableTagsVC: AvailableTagsVC) {
        showDropAreaForTagDeletingAndEditing()
        let heightNeeded = max(dropAreaViewForTagEditing.bounds.height, dropAreaViewForTagDeleting.bounds.height)
        unfoldDropAreasRow(toHeight: heightNeeded)
    }
    func availableTagsVCDidEndDrag(_ availableTagsVC: AvailableTagsVC) {
        foldDropAreasRow(andThen: { self.hideDropAreaForTagDeleingAndEditing() } )
    }
    
    func tagsAddedToTaskVCDidBeginDrag(_ tagsAddedToTaskVC: TagsAddedToTaskVC) {
        showDropAreaForRemovingOfTagFromTask()
        let heightNeeded = dropAreaViewForRemovingTagFromTask.bounds.height
        unfoldDropAreasRow(toHeight: heightNeeded)
    }
    func tagsAddedToTaskVCDidEndDrag(_ tagsAddedToTaskVC: TagsAddedToTaskVC) {
        foldDropAreasRow(andThen: { self.hideDropAreaForRemovingOfTagFromTask() })
    }
    func tagsAddedToTaskVCDidUpdateTags(_ tagsAddedToTaskVC: TagsAddedToTaskVC) {
        tagsAddedToTask = tagsAddedToTaskVC.tagsAddedToTaskStore
    }
    
    func deleteTagDropAreaVC(_ deleteTagVC: DeleteTagDropAreaVC, needsToBeDeleted tag: Tag) {
        tagsAddedToTaskVC.removeFromTask(tag)
        tagFactory.deleteTagFromMemory(tag)
        
    }
    
    func editTagDropAreaVCDelegate(_ editTagDropAreaVC: EditTagDropAreaVC, tagNeedsToBeEdited tag: Tag) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let editTagVC = storyBoard.instantiateViewController(withIdentifier: "EditTagVC") as! EditTagVC
        editTagVC.tag = tag
        editTagVC.delegate = self
        present(editTagVC, animated: true, completion: nil)
    }
    
    func editTagVC(_ editTagVC: EditTagVC, didEditTag tag: Tag) {
        tagsAddedToTaskVC.tagAddedToTaskWasUpdated(tag)
    }
    
    func removeTagFromTaskDropAreaVC(_ removeTagFromTaskDropAreaVC: RemoveTagFromTaskDropAreaVC, removeTagFromTask tag: Tag) {
        tagsAddedToTaskVC.removeFromTask(tag)
    }
    
    //MARK: UIContentContainer protocol
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        switch container {
        case let vc where vc is DeadlineVC:
            setDeadlineViewHeight(to: container.preferredContentSize.height)
         
        case let vc where vc is TagsAddedToTaskVC:
            print("frame \(q.frame.height)")
            setTagsAddedToTaskViewHeight(to: container.preferredContentSize.height)
            print("frame \(q.frame.height)")
        default: break
        }
    }
    
}

extension CreateTaskVC {
    private func showDropAreaForTagDeletingAndEditing() {
        dropAreaViewForTagDeleting.isHidden = false
        dropAreaViewForTagEditing.isHidden = false
    }
    private func hideDropAreaForTagDeleingAndEditing() {
        dropAreaViewForTagDeleting.isHidden = true
        dropAreaViewForTagEditing.isHidden = true
    }
    private func showDropAreaForRemovingOfTagFromTask() {
        dropAreaViewForRemovingTagFromTask.isHidden = false
    }
    private func hideDropAreaForRemovingOfTagFromTask() {
        dropAreaViewForRemovingTagFromTask.isHidden = true
    }
    private func setDeadlineViewHeight(to height: CGFloat) {
        tableView.performBatchUpdates({
            self.deadlineViewHeightConstraint.constant = height
        }, completion: nil)
    }
    private func setTagsAddedToTaskViewHeight(to height: CGFloat) {
        tableView.performBatchUpdates({
            self.tagsAddedToTaskHeightConstraint.constant = height
        }, completion: nil)
    }
    private func unfoldDropAreasRow(toHeight height: CGFloat) {
        tableView.beginUpdates()
        dropAreasHeight.constant = height
        tableView.endUpdates()
    }
    private func foldDropAreasRow(andThen completion: @escaping ()->()) {
        tableView.performBatchUpdates({
            self.dropAreasHeight.constant = foldedDropAreasCellHeight
        }, completion: { _ in
            completion()
        })
    }
    private func updateGoButtonEnability() {
        goButton.isEnabled = isGoButtonEnabled
    }
}

