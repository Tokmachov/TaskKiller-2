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
    
    private var taskStaticInfoLabelsController: TaskStaticInfoUpdatable!
    
    private var taksTateRepresentingViewsController: TaskStateRepresenting!
    
    private var progressTimesLabelsController: ProgressTimesLabelsController!
    private var taskProgressTimesUpdater: TaskProgressTimesTracker!
    
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
    
        taskStaticInfoLabelsController = TaskStaticInfoLabelsController(
            forDescription: taskDescriptionLabel,
            forInitialDeadLine: taskInitialDeadLineLabel
        )
        
        taksTateRepresentingViewsController = TaskStateRepresentingViewsController(startButton: startButton)
        
        deadlinePostponingVCFactory = DeadlinePostponingVCFactory(possibleDeadlines: possibleDeadlines, postponeHandler: postponeDeadlineHandler, finishHandler: finishTaskHandler )
        deadlinePostponingVC = deadlinePostponingVCFactory.createDeadlinePostponingVC()
        
        progressTimesLabelsController = ProgressTimesLabelsController(
            timeSpentInProgressLabel: timeSpentInProgressLabel,
            timeLeftToDeadLineLabel: timeLeftToDeadlineLabel
        )
        setupProgressTimesUpdater()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskStaticInfoLabelsController.updateStaticInfo(taskHandler)
    }
    private func setupProgressTimesUpdater() {
        taskProgressTimesUpdater = TaskProgressTimesTracker(initialProgressTimesSource: taskHandler, progressTimesReceiver: self)
    }
    private func updateProgressTimesUpdater() {
        taskProgressTimesUpdater.updateProgressTimes(taskHandler)
    }
    @objc private func didBecomeActive() {
        
    }
    @objc private func willEnterForeground() {
        taskState.saveState()
        updateProgressTimesUpdater()
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
        taksTateRepresentingViewsController.makeStartedUI()
        taskProgressTimesUpdater.stopTrackingProgressTimes()
    }
    func stateDidChangedToStarted() {
        taksTateRepresentingViewsController.makeStoppedUI()
        taskProgressTimesUpdater.startTrackingProgressTimes()
    }
    
    //MARK: PostponeTimeReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {}
    
    //MARK: ProgressTimesReceiver
    func receiveProgressTimes(_ progressTimesSource: TaskProgressTimesCreating) {
        progressTimesLabelsController.updateProgressTimes(progressTimesSource)
    }
}

extension TaskVC {
    private func exitTask() {
        taskState.saveState()
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
}
