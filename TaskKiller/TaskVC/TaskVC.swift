//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, TaskModelHandlingProgressEditingDecoratorSetupable  {
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    private var taskModelProgressEditingHandler: IInfoGetableTaskHandler!
    private var taskStaticInfoDisplayingUIComponents: TaskStaticInfoSetable!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskStaticInfoDisplayingUIComponents =  TaskStaticInfoDisplayingUIComponents(taskDescriptionLabel: taskDescriptionLabel,
                                                                                     initialDeadLineLabel: initialDeadLineLabel,
                                                                                     tagsLabel:            tagsLabel)
        taskStaticInfoUpdater = TaskStaticInfoUpdater()
        
        taskStaticInfoUpdater.update(taskStaticInfoDisplayingUIComponents, from: taskModelProgressEditingHandler)
    }
    
    //MARK: TaskProgressTracking
    func setTaskProgressTracker(_ tracker: IInfoGetableTaskHandler) {
        self.taskModelProgressEditingHandler = tracker
    }

    
}
