//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskVC: UIViewController, TaskProgressTrackingVC, TaskStateDelegate, ProgressTimesReceiver, TaskAlarmsReceivingDelegate {
  
    //MARK: TaskProgressTrackingVC
    func setProgressTrackingTaskHandler(_ taskHandler: TaskProgressSavingModel) {
        self.model = taskHandler
    }
    lazy private var userDefaults = UserDefaults(suiteName: AppGroupsID.taskKillerGroup)
    lazy private var possibePostponeTimes = userDefaults?.dictionary(forKey: UserDefaultsKeys.postponeTimesActionKeysAndValues) as! [String : TimeInterval]
    lazy private var possibleBreakTimes = userDefaults?.dictionary(forKey: UserDefaultsKeys.breakTimesActionKeysAndTimeValues) as! [String : TimeInterval]
    lazy private var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = .second
        return formatter
    }()
    
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
            showAddTimeVC()
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
    func receiveProgressTimes(_ progressTimesSource: ProgressTimesSource) {
        taskProgressTimesLabelsController.updateProgressTimes(progressTimesSource)
    }
    
    //MARK: TaskTimeOutAlarmReceivingDelegate
    func didReceiveAlarmWithResponseOfType(_ responseType: AlarmResponseType) {
        switch responseType {
        case .finishTask:
            finishTask()
            removeBadgeFromIcon()
        case .needMoreTime(let time):
            didReceiveAdditionalWorkTime(time)
        case .needABreak(let time):
            didReceiveBreakTime(time)
        case .defaultAlarmResponse:
            taskState.goToStoppedState()
            showAddTimeVC()
            removeBadgeFromIcon()
        }
    }
    func didReceiveAlarmInForeGround() {
        taskState.goToStoppedState()
        showAddTimeVC()
        removeBadgeFromIcon()
    }
    func didDismissAlarm() {
        taskState.goToStoppedState()
        removeBadgeFromIcon()
    }
    
    //MARK: AdditionalTimeReceiving
    private func didReceiveAdditionalWorkTime(_ workTime: TimeInterval) {
        taskState.goToStoppedState()
        model.postponeDeadlineFor(workTime)
        taskState.goToStartedState()
        removeBadgeFromIcon()
    }
    private func didReceiveBreakTime(_ breakTime: TimeInterval) {
        self.taskState.goToStoppedState()
        self.taskTimeOutAlarmController.addBreakTimeOutAlarmThatFiresIn(breakTime, alarmInfo: self.model)
        removeBadgeFromIcon()
    }
}

extension TaskVC {
    private func finishTask() {
        taskState.goToStoppedState()
        self.performSegue(withIdentifier: "Back To Task List", sender: nil)
    }
    private func removeBadgeFromIcon() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    //MARK: showAddTimeVC()
    private func showAddTimeVC() {
        let vc = createAddTimeVC()
        present(vc, animated: true, completion: nil)
    }
    private func createAddTimeVC() -> UIAlertController {
        let vc = UIAlertController(title: "Task time is up", message: "Do you need more time?", preferredStyle: .actionSheet)
        let addTaskTimeAction = createAddTaskTimeAction()
        let addBreakTimeAction = createAddBreakTimeAction()
        let finishAction = createFinishTaskAction()
        vc.addActions([addTaskTimeAction, addBreakTimeAction, finishAction])
        return vc
    }
    private func createAddTaskTimeAction() -> UIAlertAction {
        let action = UIAlertAction(title: "Add more time", style: .default, handler: { _ in self.showAddWorkTimeVC() })
        return action
    }
    private func createAddBreakTimeAction() -> UIAlertAction {
        let action = UIAlertAction(title: "Add break time", style: .default, handler: {_ in self.showAddBreakTimeVC() })
        return action
    }
    private func createFinishTaskAction() -> UIAlertAction {
        let action = UIAlertAction(title: "Finish task", style: .default, handler: { _ in self.finishTask() })
        return action
    }
    //MARK: showAddTaskTimeVC()
    private func showAddWorkTimeVC() {
        let vc = createAddWorkTimeVC()
        present(vc, animated: true, completion: nil)
    }
    private func createAddWorkTimeVC() -> UIAlertController {
        let vc = UIAlertController(title: "Add more time", message: nil, preferredStyle: .actionSheet)
        let addMoreTimeActions = createAddWorkTimeActions()
        vc.addActions(addMoreTimeActions)
        return vc
    }
    private func createAddWorkTimeActions() -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        let postponeTimes = self.possibePostponeTimes.sorted { $0.value < $1.value }.map { $0.value }
        for time in postponeTimes {
            let formattedTime = dateComponentsFormatter.string(from: time)!
            let action = UIAlertAction(title: "Add \(formattedTime) more", style: .default, handler: { (action) in
                self.didReceiveAdditionalWorkTime(time)
            })
            actions.append(action)
        }
        return actions
    }
    
    //MARK: showAddBreakTime()
    private func showAddBreakTimeVC() {
        let vc = createAddBreakTimeVC()
        present(vc, animated: true, completion: nil)
    }
    private func createAddBreakTimeVC() -> UIAlertController {
        let vc = UIAlertController(title: "Need a break time", message: nil, preferredStyle: .actionSheet)
        let actions = createAddBreakTimeActions()
        vc.addActions(actions)
        return vc
    }
    private func createAddBreakTimeActions() -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        let breakTimes = possibleBreakTimes.sorted { $0.value < $1.value }.map { $0.value }
        for time in breakTimes {
            let formattedTime = dateComponentsFormatter.string(from: time)!
            let action = UIAlertAction(title: "Add \(formattedTime) break", style: .default, handler: { _ in self.didReceiveBreakTime(time)})
            actions.append(action)
        }
        return actions
    }
}
