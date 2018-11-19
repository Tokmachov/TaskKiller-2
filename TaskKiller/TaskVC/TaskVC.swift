//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, ITaskProgressTrackingVC, TimeSpentInProgressReceiving, PostponableDeadlineReceiving {
  
   
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeToNextDeadlineLabel: UILabel!
    
    private let possibleDeadlines: [TimeInterval] = [10, 20, 30]
    
    private var taskState: (TaskStatable & TaskProgressTimesGetable & TaskProgressInfoGetable)!
    private var modelHandler: ITaskProgressTrackingModelHandler! {
        didSet {
            let progressTimes = modelHandler.getProgressTimes()
            taskState = TaskState(taskProgressTimes: progressTimes)
        }
    }
    private var taskStaticInfoDisplayingUIComponents: TaskStaticInfoSetable!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    private var stateRepresentor: StateRepresenting!
    private var stateRepresentingUIComponents: StateRepresentingUIComponents!
    private var taskProgressTimesDisplayingUIComponents: TaskProgressTimesSetable!
    private var taskProgressTimesDisplayUpdater: TaskProgressTimesUpdating!
    private var timeCounter: TimeCounting!
    private var alarmClock: Alarming!
    private var deadLinePostponingVC: DeadlinePostponingVC!
    private lazy var postponeDeadline: (TimeInterval) -> () = { [weak self] postponeTime in
        guard let self = self else { fatalError() }
        self.receivePostponeTime(postponeTime)
    }
    private lazy var finishTaskAction: ()->() = { self.finishWorkingWithTask() }
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskStaticInfoDisplayingUIComponents =  TaskStaticInfoDisplayingUIComponents(taskDescriptionLabel: taskDescriptionLabel,
                                                                                     initialDeadLineLabel: initialDeadLineLabel,
                                                                                     tagsLabel:            tagsLabel)
        stateRepresentingUIComponents = StateUIComponents(startButton: startButton)
        taskProgressTimesDisplayingUIComponents = TaskProgressTimesDisplayingUIComponents(timeSpentInprogressDisplay: timeSpentInProgressLabel,
                                                                                          timeLeftToNextDeadLineDisplay: timeToNextDeadlineLabel)
        taskStaticInfoUpdater = TaskStaticInfoUpdater()
        stateRepresentor = StateRepresentor()
        taskProgressTimesDisplayUpdater = TaskProgressTimesUpdater()
        timeCounter = createTimeCounter(initialTimeSpecntInProgressSource: taskState, timeSpentInProgressReceiver: self)
        alarmClock = createAlarmClock(timeWhenFiresSource: taskState)
        let deadLinePostponingVCFactory = DeadlinePostponingVCFactory(possibleDeadlines: possibleDeadlines, postponeAction: postponeDeadline, finishAction: finishTaskAction )
        deadLinePostponingVC = deadLinePostponingVCFactory.createDeadlinePostponingVC()
        taskStaticInfoUpdater.update(taskStaticInfoDisplayingUIComponents, from: modelHandler)
        stateRepresentor.makeStopped(stateRepresentingUIComponents)
        taskProgressTimesDisplayUpdater.update(taskProgressTimesDisplayingUIComponents, from: taskState)
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
        default: break
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
        taskProgressTimesDisplayUpdater.update(taskProgressTimesDisplayingUIComponents, from: taskState)
    }
    
    //MARK: PostponableDeadlineReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {
        alarmClock.postponeDeadLine(for: postponeTime)
        taskState.postponeDeadLine(for: postponeTime)
        timeCounter.start()
    }
    
    //MARK: ITaskProgressTrackingVC
    func setTaskProgressTrackingModelHandler(_ tracker: ITaskProgressTrackingModelHandler) {
        self.modelHandler = tracker
    }
}

extension TaskVC {
    private func createAlarmClock(timeWhenFiresSource: TaskProgressTimesGetable) -> Alarming {
        let progresstimes = timeWhenFiresSource.getProgressTimes()
        let timeWhenFires = progresstimes.currentDeadLine
        return AlarmClock(fireTime: timeWhenFires)
    }
    private func createTimeCounter(initialTimeSpecntInProgressSource: TaskProgressTimesGetable, timeSpentInProgressReceiver: TimeSpentInProgressReceiving) -> TimeCounting {
        let progessTimes = initialTimeSpecntInProgressSource.getProgressTimes()
        let initialTimeSpentInProgress = progessTimes.timeSpentInprogress
        return TimeCounter(initialTimeSpentInProgress: initialTimeSpentInProgress, timeSpentInprogressReceiver: self)
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
        stateRepresentor.makeStarted(stateRepresentingUIComponents)
    }
    private func stopTask() {
        timeCounter.stop()
        stateRepresentor.makeStopped(stateRepresentingUIComponents)
        modelHandler.saveTaskProgress(progressInfoSource: taskState)
    }
}
