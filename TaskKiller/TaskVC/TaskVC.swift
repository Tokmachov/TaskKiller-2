//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskVC: UIViewController, TaskProgressTrackingVC, PostponeTimeReceiving, TaskStateDelegate, ProgressTimesReceiver, TaskTimeOutAlarmReceivingDelegate {

    //MARK: TaskProgressTrackingVC
    func setProgressTrackingTaskHandler(_ taskHandler: ProgressTrackingTaskHandler) {
        self.taskHandler = taskHandler
    }
    
    private let deadlines: [TimeInterval] = [10, 20, 30]
   
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskInitialDeadLineLabel: UILabel!
    @IBOutlet weak var taskTagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeLeftToDeadlineLabel: UILabel!
    
    private var taskHandler: ProgressTrackingTaskHandler!
    private var taskState: TaskState!
    private var foreGroundTaskProgressTimesTracker: TaskProgressTimesUIUpdateProvider!
    private var taskTimeOutAlarmController: TaskAlarmControlling!
    
    private var taskStaticInfoLabelsController: TaskStaticInfoUpdatable!
    private var taskProgressTimesLabelsController: ProgressTimesLabelsController!
    private var taksStateRepresentingViewsController: TaskStateRepresenting!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskState = TaskStateImp(stateSavingDelegate: self)
        
        taskTimeOutAlarmController = TaskTimeOutAlarmController(alarmReceivingDelegate: self)
        
        taskStaticInfoLabelsController =
            TaskStaticInfoLabelsController(
                forDescription: taskDescriptionLabel,
                forInitialDeadLine: taskInitialDeadLineLabel
            )
        
        taskProgressTimesLabelsController =
            ProgressTimesLabelsController(
                timeSpentInProgressLabel: timeSpentInProgressLabel,
                timeLeftToDeadLineLabel: timeLeftToDeadlineLabel
            )
        
        taksStateRepresentingViewsController =
            TaskStateRepresentingViewsController(
                startButton: startButton
            )
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskStaticInfoLabelsController.updateStaticInfo(taskHandler)
        setupForeGroundTaskProgressTimesUpdater()
    }
    @objc private func willEnterForeground() {
        taskState.saveState()
        updateInitialStateOfForegroundProgressTimesTracker()
    }
   
    @IBAction func playButtonPressed() {
        taskState.saveState()
        taskState.goToNextState()
    }
    @IBAction func doneButtonPressed() {
        self.exitTask()
    }
    
    //MARK: TaskStateDelegate
    func saveTaskProgressPeriod(_ period: TaskProgressPeriod) {
        taskHandler.saveTaskProgressPeriod(period)
    }
    func stateDidChangedToNotStarted() {
        taksStateRepresentingViewsController.makeStoppedUI()
        foreGroundTaskProgressTimesTracker.stopProvidingProgressTimesForUIUpdate()
        taskTimeOutAlarmController.removeAlarm()
    }
    func stateDidChangedToStarted() {
        taksStateRepresentingViewsController.makeStartedUI()
        foreGroundTaskProgressTimesTracker.startProvidingProgressTimesForUIUpdate()
        
        switch taskHandler.getTimeLeftToDeadLine() {
        case .noTimeLeft: showDeadlinePostponingVC()
        case .timeLeft(let time): taskTimeOutAlarmController.addAlarmThatFiresIn(time, alarmInfo: taskHandler)
        }
        
    }
    
    //MARK: ProgressTimesReceiver
    func receiveProgressTimes(_ progressTimesSource: TaskProgressTimesCreating) {
        taskProgressTimesLabelsController.updateProgressTimes(progressTimesSource)
    }
    
    //MARK: TaskTimeOutAlarmReceivingDelegate
    func didReceiveTaskTimeOutAlarm() {
        taskState.saveState()
        taskState.goToNextState()
        showDeadlinePostponingVC()
    }
    
    //MARK: PostponeTimeReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {
        taskHandler.postponeDeadlineFor(postponeTime)
        switch taskHandler.getTimeLeftToDeadLine() {
        case .noTimeLeft: showDeadlinePostponingVC()
        case .timeLeft(let time):
            updateInitialStateOfForegroundProgressTimesTracker()
            taskTimeOutAlarmController.addAlarmThatFiresIn(time, alarmInfo: taskHandler)
        }
    }
}

extension TaskVC {
    private func exitTask() {
        taskState.saveState()
        taskTimeOutAlarmController.removeAlarm()
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
}

extension TaskVC {
    private func setupForeGroundTaskProgressTimesUpdater() {
        foreGroundTaskProgressTimesTracker = TaskProgressTimesUIUpdateProvider(initialProgressTimesSource: taskHandler, progressTimesReceiver: self)
    }
    private func updateInitialStateOfForegroundProgressTimesTracker() {
        foreGroundTaskProgressTimesTracker.updateProgressTimes(taskHandler)
    }
    private func showDeadlinePostponingVC() {
        let deadlinePostponingVC = createDeadLinePostponingVC()
        present(deadlinePostponingVC, animated: true, completion: nil)
    }
    private func createDeadLinePostponingVC() -> DeadlinePostponingVC {
        let factory = DeadlinePostponingVCFactoryImp()
        let deadlinPostponingHandler: (TimeInterval) -> () = { [weak self] postponeTime in
            guard let self = self else { fatalError() }
            self.receivePostponeTime(postponeTime)
        }
        let finishTaskHandler: ()->() = { self.doneButtonPressed() }
        let deadLinePostponingVC = factory.createDeadlinePostponingVC(deadlines: deadlines, postponeHandler: deadlinPostponingHandler, finishHandler: finishTaskHandler)
        return deadLinePostponingVC
    }
}
