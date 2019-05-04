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
    
    private lazy var tagFactory: TagFactory = TagFactoryImp()
    private lazy var taskFactory: TaskFactory = TaskFactoryImp(tagFactory: tagFactory)
    private lazy var taskProgressModelFactory: TaskProgressModelFactory = TaskProgressModelFactoryImp()
    
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
    private var taskStaticInfo: TaskStaticInfo {
        return TaskStaticInfo(taskDescription: taskDescription!,
                              initialDeadLine: deadline!,
                              tagsStore: tagsAddedToTask!
        )
    }
    
    //MARK: State flags
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
    private var isInTagAddingProcess = false
    
    //MARK: Cell height values
    private let foldedDropAreasCellHeight: CGFloat = 0
    private let foldedAvailableTagsCellHeight: CGFloat = 0
    private var unfoldedAvailableTagsCellHeight: CGFloat {
        let minimumHeight = tableView.bounds.height / 7
        let maximumHeight = tableView.bounds.height / 2.5
        return min(max(minimumHeight, availableTagsVC.heightOfContent), maximumHeight) + createTagButton.intrinsicContentSize.height
    }
    private var availableTagsCellIndexPath: IndexPath {
        return tableView.indexPath(for: availableTagsCell)!
    }
    
    //MARK: Cell height constraints outlets
    @IBOutlet weak var deadlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropAreasHeight: NSLayoutConstraint!
    @IBOutlet weak var tagsAddedToTaskHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var availableTagsViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Views outlets
    @IBOutlet weak var dropAreaViewForTagDeleting: UIView!
    @IBOutlet weak var dropAreaViewForRemovingTagFromTask: UIView!
    @IBOutlet weak var dropAreaViewForTagEditing: UIView!
    @IBOutlet weak var goButton: UIBarButtonItem!
    @IBOutlet weak var availableTagsCell: UITableViewCell!
    @IBOutlet weak var tagAddingButton: UIButton!
    @IBOutlet weak var createTagButton: UIButton!
    
    //MARK: Child ViewControllers
    private weak var tagsAddedToTaskVC: TagsAddedToTaskVC!
    private weak var taskDescriptionVC: TaskDescriptionVC!
    private weak var availableTagsVC: AvailableTagsVC!
    
    //MARK: VC lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideDropAreaForTagDeleingAndEditing()
        hideDropAreaForRemovingOfTagFromTask()
        updateGoButtonEnability()
        foldAvailableTagsViewRow()
        changeTagAddingButtonToAdd()
    }
    
    //MARK: Sugues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TaskDescriptionVC":
            taskDescriptionVC = (segue.destination as! TaskDescriptionVC)
            taskDescriptionVC.delegate = self
        case "DeadlineVC":
            let vc = segue.destination as! DeadlineVC
            vc.delegate = self
            addChild(vc)
        case "CreateTagVC":
            let vc = (segue.destination as? UINavigationController)?.viewControllers.first as! CreateTagVC
            vc.delegate = self
        case "AvailableTagsVC":
            availableTagsVC = (segue.destination as! AvailableTagsVC)
            availableTagsVC.delegate = self
        case "DeleteTagDropAreaVC":
            let vc = segue.destination as! DeleteTagDropAreaVC
            vc.delegate = self
        case "EditTagDropAreaVC":
            let vc = segue.destination as! EditTagDropAreaVC
            vc.delegate = self
        case "TagsAddedToTaskVC":
            tagsAddedToTaskVC = (segue.destination as! TagsAddedToTaskVC)
            tagsAddedToTaskVC.delegate = self
            addChild(tagsAddedToTaskVC)
        case "RemoveTagFromTaskVC":
            let vc = segue.destination as! RemoveTagFromTaskDropAreaVC
            vc.delegate = self 
        case "StartNewTask":
            guard let taskProgressVC = segue.destination as? TaskProgressVC else { fatalError() }
            let task = taskFactory.makeTask(taskStaticInfo: taskStaticInfo)
            let taskProgressModel = taskProgressModelFactory.makeTaskProgressModel(task: task)
            taskProgressVC.model = taskProgressModel
        default: break
        }
    }
    //MARK: Actions
    @IBAction func addTagButtonWasPressed() {
        switch isInTagAddingProcess {
        case true:
            stopAddingTags()
        case false:
            startAddingTags()
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
    func deadlineVCDidShowDatePicker(_ deadLineVC: DeadlineVC) {
        taskDescriptionVC.finishTextInput()
    }
    
    func createTagVC(_ createTagVC: CreateTagVC, didChooseName name: String, AndColor color: UIColor) {
        _ = tagFactory.makeTag(name: name, color: color)
    }
    
    func availableTagsVCDidBegingDrag(_ availableTagsVC: AvailableTagsVC) {
        showDropAreaForTagDeletingAndEditing()
    }
    func availableTagsVCDidEndDrag(_ availableTagsVC: AvailableTagsVC) {
        hideDropAreaForTagDeleingAndEditing()
    }
    
    func tagsAddedToTaskVCDidBeginDrag(_ tagsAddedToTaskVC: TagsAddedToTaskVC) {
        showDropAreaForRemovingOfTagFromTask()
    }
    func tagsAddedToTaskVCDidEndDrag(_ tagsAddedToTaskVC: TagsAddedToTaskVC) {
        hideDropAreaForRemovingOfTagFromTask()
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
            setTagsAddedToTaskViewHeight(to: container.preferredContentSize.height)
        default: break
        }
    }
    
}

extension CreateTaskVC {
    private func updateGoButtonEnability() {
        goButton.isEnabled = isGoButtonEnabled
    }
    private func showDropAreaForTagDeletingAndEditing() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dropAreaViewForTagDeleting.isHidden = false
            self.dropAreaViewForTagEditing.isHidden = false
            self.dropAreaViewForTagDeleting.alpha = 1
            self.dropAreaViewForTagEditing.alpha = 1
        }, completion: nil)
    }
    private func hideDropAreaForTagDeleingAndEditing() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dropAreaViewForTagDeleting.alpha = 0
            self.dropAreaViewForTagEditing.alpha = 0
        }, completion: {_ in
            self.dropAreaViewForTagDeleting.isHidden = true
            self.dropAreaViewForTagEditing.isHidden = true
        })
    }
    private func showDropAreaForRemovingOfTagFromTask() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dropAreaViewForRemovingTagFromTask.isHidden = false
            self.dropAreaViewForRemovingTagFromTask.alpha = 1
        }, completion: nil)
    }
    private func hideDropAreaForRemovingOfTagFromTask() {
        UIView.animate(withDuration: 0.3, animations: {
            self.dropAreaViewForRemovingTagFromTask.alpha = 0
        }, completion: { _ in
            self.dropAreaViewForRemovingTagFromTask.isHidden = true
        })
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
    
    private func stopAddingTags() {
        isInTagAddingProcess = false
        changeTagAddingButtonToAdd()
        foldAvailableTagsViewRow()
    }
    private func startAddingTags() {
        isInTagAddingProcess = true
        taskDescriptionVC.finishTextInput()
        changeTagAddingButtonToDone()
        unfoldAvailableTagsRow { self.positionAvailableTagsRow() }
    }
    
    private func changeTagAddingButtonToDone() {
        guard let image = UIImage(named: "DoneTagAdding") else {
            tagAddingButton.setTitle("Done", for: .normal)
            return
        }
        tagAddingButton.setImage(image, for: .normal)
    }
    private func changeTagAddingButtonToAdd() {
        guard let image = UIImage(named: "AddTag") else {
            tagAddingButton.setTitle("Add", for: .normal)
            return
        }
        tagAddingButton.setImage(image, for: .normal)
    }
    private func foldAvailableTagsViewRow() {
        tableView.performBatchUpdates({
            availableTagsViewHeightConstraint.constant = foldedAvailableTagsCellHeight
        }, completion: nil)
    }
    private func unfoldAvailableTagsRow(andThen completion: (()->())?) {
        
        tableView.performBatchUpdates({
            availableTagsViewHeightConstraint.constant = unfoldedAvailableTagsCellHeight
        }, completion: { _ in
            guard completion != nil else { return }
            completion!()
        })
    }
    private func positionAvailableTagsRow() {
        tableView.scrollToRow(at: availableTagsCellIndexPath, at: .bottom, animated: true)
    }
}

