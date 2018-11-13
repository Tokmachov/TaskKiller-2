//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskVC: UIViewController {
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
    @IBAction func go(_ sender: UIButton) {
       performSegue(withIdentifier: "TaskVC", sender: nil)
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
            guard let tagsVC = segue.destination as? TagsReporting else { fatalError() }
            tagsVC.setTagsReceiver(taskStaticInfoSource)
        case "TaskVC":
            guard let taskVC = segue.destination as? TaskModelHandlingProgressEditingDecoratorSetupable else { fatalError() }
            let taskStaticInfo = taskStaticInfoSource.getStaticInfo()
            let taskModelFacade = TaskModelFacadeFactory.createTaskModelHendler(from: taskStaticInfo)
            let taskProgressTracker = InfoGetableTaskHandler(taskModelFacade: taskModelFacade)
            taskVC.setTaskProgressTracker(taskProgressTracker)
        default: break
        }
    }
}

