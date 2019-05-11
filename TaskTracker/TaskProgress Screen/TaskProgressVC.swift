//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskProgressVC: UIViewController,
    TaskStateDelegate,
    UIProgressTimesUpdaterDelegate,
    AlarmsControllerDelegate
{
    
    //MARK: model
    var model: TaskProgressModel!
    
    //MARK: controllers
    private lazy var taskState: TaskState = TaskStateImp(delegate: self)
    private lazy var alarmsController: AlarmsControlling = TaskAlarmsController(delegate: self)
    private lazy var progressTimesUpdater: ProgressTimesUpdater = ProgressTimesUpdaterImp(delegate: self)
    private var progressTimesLabelsController: ProgressTimesLabelsController!
    private var taksStateRepresentingViewsController: TaskStateRepresenting!
    
    //MARK: additionslTimes with ids
    private lazy var workTimesWithIds = loadSwitchedOnWorkTimesWithIds()
    private lazy var breakTimesWithIds = loadSwitchedOnBreakTimesWithIds()
    
    //MARK: formatter
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.unitsStyle = .positional
        return formatter
    }()
    
    //MARK: outlets
    @IBOutlet weak var taskStaticInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeSpentInProgressLabel: UILabel!
    @IBOutlet weak var timeLeftToDeadlineLabel: UILabel!
    
    //MARK: VC lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressTimesLabelsController = ProgressTimesLabelsController(
                timeSpentInProgressLabel: timeSpentInProgressLabel,
                timeLeftToDeadLineLabel: timeLeftToDeadlineLabel
        )
        taksStateRepresentingViewsController = TaskStateRepresentingViewsController(
                startButton: startButton
        )
        taksStateRepresentingViewsController.makeStoppedUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressTimesUpdater.updateProgressTimes(from: model)
    }
    
    //MARK: prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TaskStaticInfoVC":
            let taskStaticInfoVC = segue.destination as! TaskStaticInfoViewController
            taskStaticInfoVC.staticInfo = model.taskStaticInfo
            addChild(taskStaticInfoVC)
        default: break
        }
    }
    
    //MARK: preferredContentSizeDidChange
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        switch container {
        case let vc where vc is TaskStaticInfoViewController:
            setTaskStaticInfoViewHeightTo(container.preferredContentSize.height)
        default: break
        }
    }
    
    //MARK: actions
    @IBAction func playButtonPressed() {
        taskState.goToNextState()
    }
    @IBAction func doneButtonPressed() {
        finishTask()
    }
    
    //MARK: delege
    func taskStateCanChangeToStarted(_ taskState: TaskState) -> Bool {
        switch model.progressTimes.timeLeftToDeadLine {
        case .noTimeLeft:
            showAddTimeVC()
            return false
        case .timeLeft: return true
        }
    }
    func taskState(_ taskState: TaskState, didDidChangeToStartedWith date: Date) {
        guard case .timeLeft = model.progressTimes.timeLeftToDeadLine else { fatalError() }
        alarmsController.removeBreakTimeOutAlarm()
        alarmsController.addTaskTimeOutAlarmThatFiresIn(model.progressTimes.timeLeftToDeadLine.timeLeft!, alarmInfo: model)
        progressTimesUpdater.startUpdatingUIProgressTimes(dateStarted: date, initialTimes: model)
        taksStateRepresentingViewsController.makeStartedUI()
    }
    func taskState(_ taskState: TaskState, didChangeToStoppedWithPeriodPassed period: ProgressPeriod) {
        model.saveProgressPeriod(period)
        alarmsController.removeTaskTimeOutAlarm()
        progressTimesUpdater.stopUpdatingUIProgressTimes()
        taksStateRepresentingViewsController.makeStoppedUI()
    }
    
    func progressTimesUpdaterDidUpdateProgressTimes(_ progressTimesUpdater: ProgressTimesUpdater) {
        progressTimesLabelsController.updateProgressTimes(from: progressTimesUpdater)
    }

    func alarmsController(_ alarmsController: AlarmsControlling, didReceiveAlarmWithResponseType responseType: AlarmResponseType) {
        removeBadgeFromIcon()
        switch responseType {
        case .finishTask:
            finishTask()
        case .addWorkTime(let time):
            addWorkTimeToTask(time)
        case .addBreak(let time):
            takeABreak(time)
        case .defaultAlarmResponse:
            taskState.goToStoppedState()
            showAddTimeVC()
        case .noAdditionalTimesSet:
            taskState.goToStoppedState()
        }
    }
    func didReceiveAlarmInForeGround(from alarmsController: AlarmsControlling) {
        taskState.goToStoppedState()
        showAddTimeVC()
        removeBadgeFromIcon()
    }
    func didDismissAlarm(_ alarmsController: AlarmsControlling) {
        taskState.goToStoppedState()
        removeBadgeFromIcon()
    }
}
extension TaskProgressVC: SwitchedOnAdditionalTimesWithIdsLoading {}

extension TaskProgressVC {
    private func addWorkTimeToTask(_ workTime: TimeInterval) {
        taskState.goToStoppedState()
        model.postponeDeadlineFor(workTime)
        taskState.goToStartedState()
    }
    private func takeABreak(_ breakTime: TimeInterval) {
        self.taskState.goToStoppedState()
        self.alarmsController.addBreakTimeOutAlarmThatFiresIn(breakTime, alarmInfo: self.model)
    }
    private func finishTask() {
        taskState.goToStoppedState()
        alarmsController.removeBreakTimeOutAlarm()
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
    //MARK: AddWorkTimeVC()
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
        guard !workTimesWithIds.isEmpty else {
            let action = createSetAdditionalTimesAction()
            actions.append(action)
            return actions
        }
        let addWorkTimes = self.workTimesWithIds.sorted { $0.value < $1.value }.map { $0.value }
        for time in addWorkTimes {
            let formattedTime = dateComponentsFormatter.string(from: time)!
            let action = UIAlertAction(title: "Add \(formattedTime)", style: .default, handler: { (action) in
                self.addWorkTimeToTask(time)
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
        guard !workTimesWithIds.isEmpty else {
            let action = createSetAdditionalTimesAction()
            actions.append(action)
            return actions
        }
        let breakTimes = breakTimesWithIds.sorted { $0.value < $1.value }.map { $0.value }
        for time in breakTimes {
            let formattedTime = dateComponentsFormatter.string(from: time)!
            let action = UIAlertAction(title: "Add \(formattedTime) break", style: .default, handler: { _ in self.takeABreak(time)})
            actions.append(action)
        }
        return actions
    }
    private func createSetAdditionalTimesAction() -> UIAlertAction {
        let title = "Please add times in setups"
        let action = UIAlertAction(title: title, style: .destructive, handler: nil)
        return action
    }
    private func setTaskStaticInfoViewHeightTo(_ height: CGFloat) {
        taskStaticInfoViewHeightConstraint.constant = height
    }
}


