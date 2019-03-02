//
//  TaskTimeOutAlarmController.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UserNotifications

class TaskAlarmsController: NSObject, AlarmsControlling, UNUserNotificationCenterDelegate {
    
    private lazy var workTimesWithActionIds = loadSwitchedOnWorkTimesWithIds()
    
    private lazy var breakTimesWithActionIds = loadSwitchedOnBreakTimesWithIds()
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = .second
        formatter.unitsStyle = .full
        return formatter
    }()
    
    private var alarmsControllerDelegate: AlarmsControllerDelegate!
    private let notificationCenter = UNUserNotificationCenter.current()
    private let taskTimeOutNotificationRequestIdentifier = UUID().uuidString
    private let breakTimeOutNotificationRequestIdentifier = UUID().uuidString
    required init(alarmsControllerDelegate: AlarmsControllerDelegate) {
        self.alarmsControllerDelegate = alarmsControllerDelegate
        super.init()
        notificationCenter.delegate = self
    }
    
    //MARK: TaskAlarmControlling
    func addTaskTimeOutAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoSource) {
        let actions = createTaskTimeOutAlarmActions()
        let category = createCategory(from: actions, andIdentifier: CategoriesInfo.taskTimeOutCategory.id)
        let content = createNotificationContentForTaskTimeOutAlarm(from: taskStaticInfoSource)
        content.categoryIdentifier = CategoriesInfo.taskTimeOutCategory.id
        let trigger = createNotificationTrigger(from: timeInterval)
        notificationCenter.setNotificationCategories([category])
        let request = createNotificationRequest(withContent: content, trigger: trigger, andId: taskTimeOutNotificationRequestIdentifier)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    func addBreakTimeOutAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoSource) {
        let content = createNotificationContentForBreakIsOverAlarm(from: taskStaticInfoSource)
        content.categoryIdentifier = CategoriesInfo.breakTimeOutCategory.id
        let trigger = createNotificationTrigger(from: timeInterval)
        
        let actions = createBreakTimeOutAlarmActions()
        let category = createCategory(from: actions, andIdentifier: CategoriesInfo.breakTimeOutCategory.id)
        notificationCenter.setNotificationCategories([category])
        
        let request = createNotificationRequest(withContent: content, trigger: trigger, andId: breakTimeOutNotificationRequestIdentifier)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    
    func removeTaskTimeOutAlarm() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [taskTimeOutNotificationRequestIdentifier])
    }
    func removeBreakTimeOutAlarm() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [breakTimeOutNotificationRequestIdentifier])
    }
    //MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        alarmsControllerDelegate.didReceiveAlarmInForeGround(from: self)
        completionHandler([.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.notificationCategoryIdentifier {
        case CategoriesInfo.taskTimeOutCategory.id: handleTaskTimeOutAlarmResponse(response)
        case CategoriesInfo.breakTimeOutCategory.id: handleBreakTimeOutAlarmResponse(response)
        default: break
        }
        completionHandler()
    }
}
extension TaskAlarmsController: SwitchedOnAdditionalTimesWithIdsLoading {}

extension TaskAlarmsController {
    private func handleTaskTimeOutAlarmResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case let id where isAddBreakTimeActionIdentifier(id):
            let breakTime = breakTimesWithActionIds[id]
            alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .addBreak(breakTime!))
        case let id where isAddWorkTimeActionIdentifier(id):
            let workTime = workTimesWithActionIds[id]
            alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .addWorkTime(workTime!))
        case CategoriesInfo.taskTimeOutCategory.actionIDs.taskIsFinished:
            alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .finishTask)
        case UNNotificationDefaultActionIdentifier:
            alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .defaultAlarmResponse)
        case UNNotificationDismissActionIdentifier:
            alarmsControllerDelegate.didDismissAlarm(self)
        case CategoriesInfo.taskTimeOutCategory.actionIDs.setWorkTimes:
            alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .noAdditionalTimesSet)
        default: break
        }
    }
    private func handleBreakTimeOutAlarmResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case let id where isAddBreakTimeActionIdentifier(id):
            let breakTime = breakTimesWithActionIds[id]
              alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .addBreak(breakTime!))
        case let id where isAddWorkTimeActionIdentifier(id):
            let workTime = workTimesWithActionIds[id]
             alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .addWorkTime(workTime!))
        case CategoriesInfo.taskTimeOutCategory.actionIDs.taskIsFinished:
           alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .finishTask)
        case UNNotificationDefaultActionIdentifier:
            alarmsControllerDelegate.alarmsController(self, didReceiveAlarmWithResponseType: .defaultAlarmResponse)
        case UNNotificationDismissActionIdentifier:
            alarmsControllerDelegate.didDismissAlarm(self)
        default: break
        }
    }
    private func isAddWorkTimeActionIdentifier(_ id: Id) -> Bool {
        return workTimesWithActionIds[id] != nil
    }
    private func isAddBreakTimeActionIdentifier(_ id: Id) -> Bool {
        return breakTimesWithActionIds[id] != nil
    }
    private func createNotificationRequest(withContent content: UNMutableNotificationContent, trigger: UNTimeIntervalNotificationTrigger, andId id: String) -> UNNotificationRequest {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        return request
    }
    private func createNotificationContentForTaskTimeOutAlarm(from taskStaticInfoSource: TaskStaticInfoSource) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "This is task time alarm"
        let taskDescription = getTaskDescriptionFrom(taskStaticInfoSource)
        content.body = "Task time of \(taskDescription) is up."
        content.sound = UNNotificationSound.default
        content.badge = 1
        return content
    }
    private func createNotificationContentForBreakIsOverAlarm(from taskStatifoSource: TaskStaticInfoSource) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        let taskDescription = getTaskDescriptionFrom(taskStatifoSource)
        let title = "Break is over"
        let body = "Let's get back to \(taskDescription)"
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        return content
    }
    private func getTaskDescriptionFrom(_ taskStaticInoSource: TaskStaticInfoSource) -> String {
        let taskStaticInfo = taskStaticInoSource.createStaticInfo()
        let taskDescription = taskStaticInfo.taskDescription
        return taskDescription
    }
    private func createNotificationTrigger(from timeInterval: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        return trigger
    }
    private func createTaskTimeOutAlarmActions() -> [UNNotificationAction] {
        let openApp = UNNotificationAction(identifier: CategoriesInfo.taskTimeOutCategory.actionIDs.openApp, title: "Open App", options: [.foreground])
        let needBreak = UNNotificationAction(identifier: CategoriesInfo.taskTimeOutCategory.actionIDs.addBreak, title: "I need a break", options: [])
        let needMoreTime = UNNotificationAction(identifier: CategoriesInfo.taskTimeOutCategory.actionIDs.addWorkTime, title: "I need more time", options: [])
        let taskIsFinished = UNNotificationAction(identifier: CategoriesInfo.taskTimeOutCategory.actionIDs.taskIsFinished, title: "I finished task", options: [.destructive])
        let actions = [needMoreTime, needBreak, taskIsFinished, openApp]
        return actions
    }
    
    
    private func createBreakTimeOutAlarmActions() -> [UNNotificationAction] {
        let openAppAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOutCategory.actionIDs.openApp, title: "Open App", options: [.foreground])
        let needMoreBreakTimeAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOutCategory.actionIDs.needBreak, title: "I need more break time", options: [])
        let getBackToTaskAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOutCategory.actionIDs.getBackToTask, title: "Get back to task", options: [])
        let finishTaskAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOutCategory.actionIDs.taskIsFinished, title: "Finish task", options: [])
        let actions = [getBackToTaskAction, needMoreBreakTimeAction, finishTaskAction, openAppAction]
        return actions
    }
    
    private func createCategory(from actions: [UNNotificationAction], andIdentifier identifier: String) -> UNNotificationCategory {
        let category = UNNotificationCategory(identifier: identifier, actions: actions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "You have action", options: [.customDismissAction])
        return category
    }
}


