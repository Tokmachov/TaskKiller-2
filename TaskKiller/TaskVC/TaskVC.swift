//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, TaskModelHandlingProgressEditingDecoratorSetupable, TimeIncrementsReceiving {
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    private var taskState: TaskStatable!
    private var taskModelProgressEditingHandler: IInfoGetableTaskHandler! {
        didSet {
            let progressTimes = taskModelProgressEditingHandler.getProgressTimes()
            taskState = TaskState(taskProgressTimes: progressTimes)
        }
    }
    private var taskStaticInfoDisplayingUIComponents: TaskStaticInfoSetable!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    private var stateRepresentor: StateRepresenting!
    private var stateRepresentingUIComponents: StateRepresentingUIComponents!
    private var timeIncrementor: TimeIncrementing!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskStaticInfoDisplayingUIComponents =  TaskStaticInfoDisplayingUIComponents(taskDescriptionLabel: taskDescriptionLabel,
                                                                                     initialDeadLineLabel: initialDeadLineLabel,
                                                                                     tagsLabel:            tagsLabel)
        stateRepresentingUIComponents = StateUIComponents(startButton: startButton)
        
        taskStaticInfoUpdater = TaskStaticInfoUpdater()
        stateRepresentor = StateRepresentor()
        timeIncrementor = TimeIncrementor(timeIncrementsReceiver: self)
        
        taskStaticInfoUpdater.update(taskStaticInfoDisplayingUIComponents, from: taskModelProgressEditingHandler)
        stateRepresentor.makeStopped(stateRepresentingUIComponents)
    }
    @IBAction func playButtonPressed() {
         taskState.changeState()
        switch taskState.getCurrentState() {
        case .started:
            timeIncrementor.start()
        case .ended:
            timeIncrementor.stop()
        default: break
        }
     
    }
    
    //MARK: TaskProgressTracking
    func setTaskProgressTracker(_ tracker: IInfoGetableTaskHandler) {
        self.taskModelProgressEditingHandler = tracker
    }
    
    //MARK: TimeIncrementsReceiving
    func receiveTimeIncrement(_ incrementValue: TimeInterval) {
        taskState.incrementTimeSpentInProcess(by: incrementValue)
    }
}


