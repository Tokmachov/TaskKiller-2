//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, ITaskProgressTrackingVC, TimeSpentInProgressReceiving, PostponeTimeReceiving {
    
    private let possibleDeadlines: [TimeInterval] = [10, 20, 30]
   
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskInitialDeadLineLabel: UILabel!
    @IBOutlet weak var taskTagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeToNextDeadlineLabel: UILabel!
    
    private var taskModelHandler: ITaskProgressTrackingModelHandler!
    private var taskState: ITaskState!
    private var taskStaticInfoViews: TaskStaticInfoSetable!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    private var taskStateRepresentableViews: TaskStateRepresentable!
    private var taskStateRepresentor: TaskStateRepresenting!
    private var taskProgressTimesViews: TaskProgressTimesSetable!
    private var taskProgressTimesUpdater: TaskProgressTimesUpdating!
    private var timeCounter: TimeCounting!
    private var alarmClock: Alarming!
    
    private var deadLinePostponingVC: DeadlinePostponingVC!
    private lazy var postponeDeadlineHandler: (TimeInterval) -> () = { [weak self] postponeTime in
        guard let self = self else { fatalError() }
        self.receivePostponeTime(postponeTime)
    }
    private lazy var finishTaskHandler: ()->() = { self.finishWorkingWithTask() }
    
    //MARK: ITaskProgressTrackingVC
    func setTaskProgressTrackingModelHandler(_ taskModelHandler: ITaskProgressTrackingModelHandler) {
        self.taskModelHandler = taskModelHandler
    }
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskState = TaskState(taskProgressTimesSource: taskModelHandler)
        self.taskStaticInfoViews =  TaskStaticInfoLabels(forDescription: taskDescriptionLabel, forInitialDeadLine: taskInitialDeadLineLabel, forTags: taskTagsLabel)
        self.taskStaticInfoUpdater = TaskStaticInfoUpdater()
        self.taskStateRepresentableViews = TaskStateRepresentableViews(startButton: startButton)
        self.taskStateRepresentor = StateRepresentor()
        self.taskProgressTimesViews = TaskProgressTimesLabels(forTimeSpentInProgress: timeSpentInProgressLabel,forTimeLeft: timeToNextDeadlineLabel)
        self.taskProgressTimesUpdater = TaskProgressTimesUpdater()
        self.timeCounter = createTimeCounter(initialTimeSource: taskState, timeUpdatesReceiver: self)
        self.alarmClock = createAlarmClock(timeWhenFiresSource: taskState)
        let deadLinePostponingVCFactory = DeadlinePostponingVCFactory(possibleDeadlines: possibleDeadlines, postponeHandler: postponeDeadlineHandler, finishHandler: finishTaskHandler )
        self.deadLinePostponingVC = deadLinePostponingVCFactory.createDeadlinePostponingVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.taskStaticInfoUpdater.update(taskStaticInfoViews, from: taskModelHandler)
        self.taskStateRepresentor.makeStopped(taskStateRepresentableViews)
        self.taskProgressTimesUpdater.update(taskProgressTimesViews, from: taskState)
    }
    @IBAction func playButtonPressed() {
        switch taskState.getCurrentState() {
        case .started:
            taskState.changeState()
            stopTask()
        case .ended:
            taskState.changeState()
            startTask()
        case .hasNotStarted:
            taskState.changeState()
            startTask()
        }
    }
    @IBAction func doneButtonPressed() {
        finishWorkingWithTask()
    }
    
    //MARK: TimeSpentInProgressReceiving
    func receiveTime(_ timeSpentInProgress: TimeInterval) {
        alarmClock.updateCurrentTime(timeSpentInProgress, fireAction: {  
            self.timeCounter.stop()
            self.present(deadLinePostponingVC, animated: true, completion: nil)
        })
        taskState.updateTimeSpentInProgress(timeSpentInProgress)
        taskProgressTimesUpdater.update(taskProgressTimesViews, from: taskState)
    }
    
    //MARK: PostponeTimeReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {
        alarmClock.postponeCurrentDeadLine(for: postponeTime)
        taskState.postponeCurrentDeadline(for: postponeTime)
        timeCounter.start()
    }
    
    
}

extension TaskVC {
    private func createAlarmClock(timeWhenFiresSource: TaskProgressTimesGetable) -> Alarming {
        let progresstimes = timeWhenFiresSource.getProgressTimes()
        let timeWhenFires = progresstimes.currentDeadLine
        return AlarmClock(fireTime: timeWhenFires)
    }
    private func createTimeCounter(initialTimeSource: TaskProgressTimesGetable, timeUpdatesReceiver: TimeSpentInProgressReceiving) -> TimeCounting {
        let progessTimes = initialTimeSource.getProgressTimes()
        let initialTimeSpentInProgress = progessTimes.timeSpentInprogress
        return TimeCounter(initialTime: initialTimeSpentInProgress, timeUpdatesReceiver: self)
    }
    private func finishWorkingWithTask() {
        switch taskState.getCurrentState() {
        case .started:
            taskState.changeState()
            stopTask()
        default: break
        }
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
    private func startTask() {
        timeCounter.start()
        taskStateRepresentor.makeStarted(taskStateRepresentableViews)
    }
    private func stopTask() {
        timeCounter.stop()
        taskStateRepresentor.makeStopped(taskStateRepresentableViews)
        taskModelHandler.saveTaskProgress(progressInfoSource: taskState)
    }
}
