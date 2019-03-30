//
//  CreateTaskVC2.swift
//  TaskKiller
//
//  Created by mac on 23/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
class CreateTaskVC2: UITableViewController, TaskDescriptionVCDelegate, DeadlineVCDelegate, CreateTagVCDelegate {
  
    private var tagFactory = TagFactoryImp()
    //MARK: Model
    private var taskDescription: String?
    private var deadline: TimeInterval?
    
    //MARK: Views
    @IBOutlet weak var deadlineViewHeightConstraint: NSLayoutConstraint!
    
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
