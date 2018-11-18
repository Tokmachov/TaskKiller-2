//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, TaskModelHandlingProgressEditingDecoratorSetupable, TimeSpentInProgressReceiving, PostponableDeadlineReceiving {
   
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var initialDeadLineLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeToNextDeadlineLabel: UILabel!
    
    private let possibleDeadlines: [TimeInterval] = [10, 20, 30]
    
    private var taskState: (TaskStatable & TaskProgressTimesGetable)!
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
    private var taskProgressTimesDisplayingUIComponents: TaskProgressTimesSetable!
    private var taskProgressTimesDisplayUpdater: TaskProgressTimesUpdating!
    private var timeCounter: TimeCounting!
    private var alarmClock: Alarming!
    private var deadLinePostponingVC: DeadlinePostponingVC!
    private lazy var postponeDeadline: (TimeInterval) -> () = { [weak self] postponeTime in
        guard let self = self else { fatalError() }
        self.receivePostponeTime(postponeTime)
    }
    private var deadlinePostponingVC: DeadlinePostponingVC!
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
        let deadLinePostponingVCFactory = DeadlinePostponingVCFactory(possibleDeadlines: possibleDeadlines, postponeAction: postponeDeadline, finishAction: {})
        deadLinePostponingVC = deadLinePostponingVCFactory.createDeadlinePostponingVC()
        taskStaticInfoUpdater.update(taskStaticInfoDisplayingUIComponents, from: taskModelProgressEditingHandler)
        stateRepresentor.makeStopped(stateRepresentingUIComponents)
        taskProgressTimesDisplayUpdater.update(taskProgressTimesDisplayingUIComponents, from: taskState)
    }
    @IBAction func playButtonPressed() {
         taskState.changeState()
        switch taskState.getCurrentState() {
        case .started:
            timeCounter.start()
            stateRepresentor.makeGoing(stateRepresentingUIComponents)
        case .ended:
            timeCounter.stop()
            stateRepresentor.makeStopped(stateRepresentingUIComponents)
        default: break
        }
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
    
    //MARK: TaskProgressTracking
    func setTaskProgressTracker(_ tracker: IInfoGetableTaskHandler) {
        self.taskModelProgressEditingHandler = tracker
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
}
