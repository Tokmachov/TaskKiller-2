//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class CreateTaskVC: UIViewController {
    
    private var taskStaticInfoSource: StaticInfoConstructing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskStaticInfoSource = StaticInfoConstructer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "TaskDescriptionChildVC":
            guard let taskDescriptionVC = segue.destination as? TaskDescriptionReporting else { fatalError() }
            taskDescriptionVC.setTaskDescriptionReceiver(taskStaticInfoSource)
        case "DeadLineChildVC":
            guard let deadLineVC = segue.destination as? DeadLineReporting else { fatalError() }
            deadLineVC.setDeadLineRerceiver(taskStaticInfoSource)
        case "TagsChildVC":
            guard let tagsVC = segue.destination as? TagsReporting else { fatalError() }
            tagsVC.setTagsReceiver(taskStaticInfoSource)
        default: break
        }
    }
}

