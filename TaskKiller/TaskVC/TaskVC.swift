//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, TaskModelHandlingProgressEditingDecoratorSetupable, TimeIncrementsReceiving, Alarmable, PostponableDeadlineChangesReceiving, CurrentTimeSpentInProgressReceiving {
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeToNextDeadlineLabel: UILabel!
    
    private var taskState: TaskStatable!
    private var taskModelProgressEditingHandler: IInfoGetableTaskHandler! {
        didSet {
            let progressTimes = taskModelProgressEditingHandler.getProgressTimes()
            taskState = TaskState(taskProgressTimes: progressTimes, postponableDeadLineChangesReceiver: self, currentTimeSpentInProgressReceiver: self)
        }
    }
    private var taskStaticInfoDisplayingUIComponents: TaskStaticInfoSetable!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    private var stateRepresentor: StateRepresenting!
    private var stateRepresentingUIComponents: StateRepresentingUIComponents!
    private var taskProgressTimesDisplayingUIComponents: TaskProgressTimesSetable!
    private var taskProgressTimesDisplayUpdater: TaskProgressTimesUpdating!
    private var timeIncrementor: TimeIncrementing!
    private var alarmClock: Alarming!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskStaticInfoDisplayingUIComponents =  TaskStaticInfoDisplayingUIComponents(taskDescriptionLabel: taskDescriptionLabel,
                                                                                     initialDeadLineLabel: initialDeadLineLabel,
                                                                                     tagsLabel:            tagsLabel)
        stateRepresentingUIComponents = StateUIComponents(startButton: startButton)
        
        taskStaticInfoUpdater = TaskStaticInfoUpdater()
        stateRepresentor = StateRepresentor()
        taskProgressTimesDisplayingUIComponents = TaskProgressTimesDisplayingUIComponents(timeSpentInprogressDisplay: timeSpentInProgressLabel,
                                                                                          timeLeftToNextDeadLineDisplay: timeToNextDeadlineLabel)
        
        taskProgressTimesDisplayUpdater = TaskProgressTimesUpdater()
        
        timeIncrementor = TimeIncrementor(timeIncrementsReceiver: self)
        alarmClock = AlarmClock(alarmReceiver: self)
        
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
        self.taskState.incrementTimeSpentInProcess(by: incrementValue)
    }
    
    //MARK: Alarmable
    func alarmDidFire() {
        timeIncrementor.stop()
    }
    
    //MARK: PostponableDeadLineChangesReceiving
    func postponableDeadLineDidchanged(_ deadline: TimeInterval) {
        alarmClock.setTimeWhenFires(deadline)
    }
    
    //MARK: CurrentTimeSpentInProgressReceiving
    func receiveCurrentTimeSpentInProgress(_ time: TimeInterval) {
        alarmClock.updateCurrentTime(time)
    }
}


