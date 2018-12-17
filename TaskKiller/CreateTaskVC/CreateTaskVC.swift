//
//  ViewController.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskVC: UIViewController, TagInfoReceiving {
    
    private var deadLinesTochose: [TimeInterval] = [10, 15, 20, 30]
    private var taskStaticInfoSource = TaskStaticInfoGatherer()
    
    @IBAction func go(_ sender: UIButton) {
       performSegue(withIdentifier: "Start New Task", sender: nil)
    }
    func receiveTagInfo(name: String, color: UIColor) {
        print("Tag Info Received: Tag Name: \(name), tag color: \(color)")
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
        case "EditTagControlPanelChildVC":
            guard let tagInfoReporter = segue.destination as? TagInfoReporting else { fatalError() }
            tagInfoReporter.setTagInfoReceiver(self)
        
        case "Start New Task":
            guard let taskVC = segue.destination as? ITaskProgressTrackingVC else { fatalError() }
            let taskStaticInfo = taskStaticInfoSource.getStaticInfo()
            let taskModelFacade = TaskModelFacadeFactory.createTaskModelFacade(from: taskStaticInfo)
            let taskProgressTrackingModelHandler = TaskProgressTrackingModelHandler(taskModelFacade: taskModelFacade)
            taskVC.setTaskProgressTrackingModelHandler(taskProgressTrackingModelHandler)
        
            
        default: break
        }
    }
}
