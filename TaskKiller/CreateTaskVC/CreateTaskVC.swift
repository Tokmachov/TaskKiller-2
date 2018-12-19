//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskVC: UIViewController, InfoForTagReceiving {
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
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
