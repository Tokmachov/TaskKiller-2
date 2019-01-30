//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskVC: UIViewController, TaskProgressTrackingVC, PostponeTimeReceiving, TaskStateDelegate, ProgressTimesReceiver {
  
    //MARK: TaskProgressTrackingVC
    func setProgressTrackingTaskHandler(_ taskHandler: ProgressTrackingTaskHandler) {
        self.taskHandler = taskHandler
    }
    
    private let possibleDeadlines: [TimeInterval] = [10, 20, 30]
   
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskInitialDeadLineLabel: UILabel!
    @IBOutlet weak var taskTagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeLeftToDeadlineLabel: UILabel!
    
    private var taskHandler: ProgressTrackingTaskHandler!
    private var taskState: TaskState!
    private var foreGroundTaskProgressTimesTracker: ForeGroundTaskProgressTimesTracker!
    private var taskTimeOutAlarmController: TaskAlarmControlling!
    
    private var taskStaticInfoLabelsController: TaskStaticInfoUpdatable!
    private var taskProgressTimesLabelsController: ProgressTimesLabelsController!
    private var taksStateRepresentingViewsController: TaskStateRepresenting!
    
    private var deadlinePostponingVCFactory: DeadlinePostponingVCFactory!
    private lazy var postponeDeadlineHandler: (TimeInterval) -> () = { [weak self] postponeTime in
        guard let self = self else { fatalError() }
        self.receivePostponeTime(postponeTime)
    }
    private lazy var finishTaskHandler: ()->() = { self.doneButtonPressed() }
    private var deadlinePostponingVC: DeadlinePostponingVC!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskState = TaskStateImp(stateSavingDelegate: self)
        setupForeGroundTaskProgressTimesUpdater()
        taskTimeOutAlarmController = taskTimeOutAlarmController()
        
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
        
        deadlinePostponingVCFactory =
            DeadlinePostponingVCFactory(
                possibleDeadlines: possibleDeadlines,
                postponeHandler: postponeDeadlineHandler,
                finishHandler: finishTaskHandler
            )
        deadlinePostponingVC = deadlinePostponingVCFactory.createDeadlinePostponingVC()
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskStaticInfoLabelsController.updateStaticInfo(taskHandler)
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
        taksStateRepresentingViewsController.makeStartedUI()
        foreGroundTaskProgressTimesTracker.stopTrackingProgressTimes()
        taskTimeOutAlarmController.removeAlarm()
    }
    func stateDidChangedToStarted() {
        taksStateRepresentingViewsController.makeStoppedUI()
        foreGroundTaskProgressTimesTracker.startTrackingProgressTimes()
        taskTimeOutAlarmController.addAlarmThatFiresIn(<#T##timeInterval: TimeInterval##TimeInterval#>, forTask: <#T##Task#>)
    }
    
    //MARK: PostponeTimeReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {}
    
    //MARK: ProgressTimesReceiver
    func receiveProgressTimes(_ progressTimesSource: TaskProgressTimesCreating) {
        taskProgressTimesLabelsController.updateProgressTimes(progressTimesSource)
    }
}

extension TaskVC {
    private func exitTask() {
        taskState.saveState()
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
}

extension TaskVC {
    private func setupForeGroundTaskProgressTimesUpdater() {
        foreGroundTaskProgressTimesTracker = ForeGroundTaskProgressTimesTracker(initialProgressTimesSource: taskHandler, progressTimesReceiver: self)
    }
    private func updateInitialStateOfForegroundProgressTimesTracker() {
        foreGroundTaskProgressTimesTracker.updateProgressTimes(taskHandler)
    }
}
