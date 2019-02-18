//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskVC: UIViewController, TaskProgressTrackingVC, PostponeTimeReceiving, TaskStateDelegate, ProgressTimesReceiver, TaskAlarmsReceivingDelegate {
  
    //MARK: TaskProgressTrackingVC
    func setProgressTrackingTaskHandler(_ taskHandler: TaskProgressSavingModel) {
        self.model = taskHandler
    }
    
    private let deadlines: [TimeInterval] = [10, 20, 30]
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskInitialDeadLineLabel: UILabel!
    @IBOutlet weak var taskTagsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeLeftToDeadlineLabel: UILabel!
    
    private var model: TaskProgressSavingModel! 
    private var taskState: TaskState!
    private var uIProgressTimesUpdater: UIProgressTimesUpdater!
    private var taskTimeOutAlarmController: TaskAlarmControlling!
    
    private var taskStaticInfoLabelsController: TaskStaticInfoUpdatable!
    private var taskProgressTimesLabelsController: ProgressTimesLabelsController!
    private var taksStateRepresentingViewsController: TaskStateRepresenting!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        taskState = TaskStateImp(stateSavingDelegate: self)
        taskTimeOutAlarmController = TaskAlarmsController(alarmReceivingDelegate: self)
        
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
        
        uIProgressTimesUpdater = UIProgressTimesUpdater(progressTimesReceiver: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        taskStaticInfoLabelsController.updateStaticInfo(model)
        uIProgressTimesUpdater.updateProgressTimes(model)
    }
    @objc private func willEnterForeground() {
        
    }
   
    @IBAction func playButtonPressed() {
        taskState.goToNextState()
    }
    
    //MARK: TaskStateDelegate
    func canChangeToStarted() -> Bool {
        switch model.timeLeftToDeadLine {
        case .noTimeLeft:
            showDeadlinePostponingVC()
            return false
        case .timeLeft: return true
        }
    }
    func statedDidChangeToStarted(dateStarted: Date) {

        guard case .timeLeft = model.timeLeftToDeadLine else { fatalError() }
        
        taskTimeOutAlarmController.addTaskTimeOutAlarmThatFiresIn(model.timeLeftToDeadLine.timeLeft!, alarmInfo: model)
        uIProgressTimesUpdater.updateProgressTimes(model)
        uIProgressTimesUpdater.startUpdatingUIProgressTimes(dateStarted: dateStarted)
        taksStateRepresentingViewsController.makeStartedUI()
    }
    func stateDidChangeToStopped(progressPeriodToSave: TaskProgressPeriod) {
        model.saveTaskProgressPeriod(progressPeriodToSave)
        taskTimeOutAlarmController.removeAlarm()
        uIProgressTimesUpdater.stopUpdatingUIProgressTimes()
        taksStateRepresentingViewsController.makeStoppedUI()
    }
    @IBAction func doneButtonPressed() {
        finishTask()
    }
     
    //MARK: ProgressTimesReceiver
    func receiveProgressTimes(_ progressTimesSource: ProgressTimesCreating) {
        taskProgressTimesLabelsController.updateProgressTimes(progressTimesSource)
        
    }
    
    //MARK: TaskTimeOutAlarmReceivingDelegate
    func didReceiveAlarmWithResponseType(_ response: AlarmResponseType) {
        switch response {
        case .finishTask:
            finishTask()
        case .needMoreTime(let time):
            taskState.goToStoppedState()
            model.postponeDeadlineFor(time)
            taskState.goToStartedState()
        case .needABreak(let time):
            taskState.goToStoppedState()
            taskTimeOutAlarmController.addBreakTimeOutAlarmThatFiresIn(time, alarmInfo: model)
        case .defaultAlarmResponse:
            taskState.goToStoppedState()
            showDeadlinePostponingVC()
        }
    }
    func didReceiveAlarmInForeGround() {
        taskState.goToStoppedState()
        showDeadlinePostponingVC()
    }
    func didDismissAlarm() {
        taskState.goToStoppedState()
    }
    
    //MARK: PostponeTimeReceiving
    func receivePostponeTime(_ postponeTime: TimeInterval) {
        taskState.goToStoppedState()
        model.postponeDeadlineFor(postponeTime)
        taskState.goToStartedState()
    }
}

extension TaskVC {
 
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
    private func finishTask() {
        taskState.goToStoppedState()
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
}
