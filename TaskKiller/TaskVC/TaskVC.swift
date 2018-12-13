//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskVC: UIViewController, ITaskProgressTrackingVC, TimeIncrementsReceiving, PostponeTimeReceiving, TaskStateChangesReceiving, AlarmReceiving {
   
    private let possibleDeadlines: [TimeInterval] = [10, 20, 30]
   
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskInitialDeadLineLabel: UILabel!
    @IBOutlet weak var taskTagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeToNextDeadlineLabel: UILabel!
    
    private var taskModelHandler: ITaskProgressTrackingModelHandler!
    private var taskState: ITaskState!
    private var alarmClock: Alarming!
    private var timeCounter: TimeCounting!
    private var taskStaticInfoViews: TaskStaticInfoSetable!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    private var taskStateRepresentableViews: TaskStateRepresentable!
    private var taskStateRepresentor: TaskStateRepresenting!
    private var taskProgressTimesViews: TaskProgressTimesSetable!
    private var taskProgressTimesUpdater: TaskProgressTimesUpdating!
    
    private var deadlinePostponingVCFactory: DeadlinePostponingVCFactory!
    private lazy var postponeDeadlineHandler: (TimeInterval) -> () = { [weak self] postponeTime in
        guard let self = self else { fatalError() }
        self.receivePostponeTime(postponeTime)
    }
    private lazy var finishTaskHandler: ()->() = { self.doneButtonPressed() }
    private var deadlinePostponingVC: DeadlinePostponingVC!
    
    //MARK: ITaskProgressTrackingVC
    func setTaskProgressTrackingModelHandler(_ taskModelHandler: ITaskProgressTrackingModelHandler) {
        self.taskModelHandler = taskModelHandler
    }
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskState = TaskState(stateChangesReceiver: self)
        alarmClock = AlarmClock(alarmReceiver: self)
        timeCounter = TimeCounter(timeUpdatesReceiver: self)
        taskStaticInfoViews =  TaskStaticInfoLabels(forDescription: taskDescriptionLabel, forInitialDeadLine: taskInitialDeadLineLabel, forTags: taskTagsLabel)
        taskStaticInfoUpdater = TaskStaticInfoUpdater()
        taskStateRepresentableViews = TaskStateRepresentableViews(startButton: startButton)
        taskStateRepresentor = StateRepresentor()
        taskProgressTimesViews = TaskProgressTimesLabels(forTimeSpentInProgress: timeSpentInProgressLabel,forTimeLeft: timeToNextDeadlineLabel)
        taskProgressTimesUpdater = TaskProgressTimesUpdater()
        deadlinePostponingVCFactory = DeadlinePostponingVCFactory(possibleDeadlines: possibleDeadlines, postponeHandler: postponeDeadlineHandler, finishHandler: finishTaskHandler )
        deadlinePostponingVC = deadlinePostponingVCFactory.createDeadlinePostponingVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskState.prepareToStartTaskStateTracking(withInitialInfoFrom: taskModelHandler)
        alarmClock.setAlarmClockCurrentAndFireTimes(from: taskState)
        taskStaticInfoUpdater.update(taskStaticInfoViews, from: taskModelHandler)
        taskStateRepresentor.makeStopped(taskStateRepresentableViews)
        taskProgressTimesUpdater.update(taskProgressTimesViews, from: taskState)
    }
    @IBAction func playButtonPressed() {
        taskState.changeState()
    }
    @IBAction func doneButtonPressed() {
        self.exitTask()
    }
    
    //MARK: TaskStateChangesReceiving
    func taskStateDidChangedToStarted() {
        timeCounter.start()
        taskStateRepresentor.makeStarted(taskStateRepresentableViews)
    }
    func taskStateDidChangedToStopped(_ taskState: TaskProgressInfoGetable) {
        timeCounter.stop()
        taskStateRepresentor.makeStopped(taskStateRepresentableViews)
        taskModelHandler.saveTaskProgress(progressInfoSource: taskState)
    }
    
    //MARK: TimeIncrementsReceiving
    func receiveTimeIncrement(_ timeIncrement: TimeInterval) {
        alarmClock.incrementCurrentTime(timeIncrement)
        taskState.incrementTimeSpentInProgress(by: timeIncrement)
        taskProgressTimesUpdater.update(taskProgressTimesViews, from: taskState)
    }
    
    //MARK: AlarmReceiving
    func alarmDidFire() {
        timeCounter.stop()
        self.present(deadlinePostponingVC, animated: true, completion: nil)
    }
    
    //MARK: PostponeTimeReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {
        alarmClock.postponeFireTime(for: postponeTime)
        taskState.postponeCurrentDeadline(for: postponeTime)
        timeCounter.start()
    }
}

extension TaskVC {
    private func exitTask() {
        taskState.prapareToStopTaskStateTracking()
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
}
