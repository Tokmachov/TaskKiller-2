//
//  CreateTaskVC2.swift
//  TaskKiller
//
//  Created by mac on 23/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
class CreateTaskVC2: UITableViewController, TaskDescriptionVCDelegate, DeadlineVCDelegate, CreateTagVCDelegate, AvailableTagsVCDelegate, DeleteTagDropAreaVCDelegate, EditTagDropAreaVCDelegate, EditTagVCDelegate {
    
  
    
 
    private var tagFactory = TagFactoryImp()
    //MARK: Model
    private var taskDescription: String?
    private var deadline: TimeInterval?
    
    //MARK: Views
    @IBOutlet weak var deadlineViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dropAreasHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        hideDropAreas()
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
            let vc = segue.destination as! CreateTagVC
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
        default: break
        }
    }
    
    //MARK: TaskDescriptionVCDelegate
    func taskDescriptionVC(_ taskDescriptionVC: TaskDescriptionVC, didEnteredDescription taskDescription: String) {
        self.taskDescription = taskDescription
    }
    //MARK: DeadlineVCDelegate
    func deadlineVC(_ deadlineVC: DeadlineVC, didChoseDeadline deadline: TimeInterval) {
        self.deadline = deadline
    }
    //MARK: CreateTagVCDelegate
    func createTagVCDelegate(_ createTagVCDelegate: CreateTagVC, didChoseName name: String, AndColor color: UIColor) {
        _ = tagFactory.createTag(name: name, color: color)
    }
    //MARK: AvailableTagsVCDelegate
    func addDeleteAndEditTagDropAreas(for: AvailableTagsVC) {
        showDropAreas()
    }
    
    func removeEditAndDeleteTagDropAreas(for: AvailableTagsVC) {
        hideDropAreas()
        
    }
    //MAR: DeleteTagDropAreaVCDelegate
    func deleteTagDropAreaVC(_ deleteTagVC: DeleteTagDropAreaVC, needToBeDeleted tag: Tag) {
        tagFactory.deleteTagFromMemory(tag)
    }
    //MARK: EditTagDropAreaVCDelegate
    func editTagDropAreaVCDelegate(_ editTagDropAreaVC: EditTagDropAreaVC, tagNeedsToBeEdited tag: Tag) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let editTagVC = storyBoard.instantiateViewController(withIdentifier: "EditTagVC") as! EditTagVC
        editTagVC.tag = tag
        editTagVC.delegate = self
        present(editTagVC, animated: true, completion: nil)
    }
    //MARK: EditTagVCDelegate
    func editTagVC(_ editTagVC: EditTagVC, didEditTag tag: Tag) {
        print("Tag was edited")
    }
    
    //MARK: UIContentContainer
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        switch container {
        case let vc where vc is DeadlineVC:
            tableView.beginUpdates()
            deadlineViewHeightConstraint.constant = container.preferredContentSize.height
            tableView.endUpdates()
        default: break
        }
    }
}

extension CreateTaskVC2 {
    private func hideDropAreas() {
        tableView.beginUpdates()
        dropAreasHeight.constant = 0
        tableView.endUpdates()
    }
    private func showDropAreas() {
        tableView.beginUpdates()
        dropAreasHeight.constant = 100
        tableView.endUpdates()
    }
}

