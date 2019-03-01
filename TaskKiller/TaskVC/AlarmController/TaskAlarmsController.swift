//
//  TaskTimeOutAlarmController.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UserNotifications

class TaskAlarmsController: NSObject, TaskAlarmControlling, UNUserNotificationCenterDelegate {
    private lazy var userDeafaults = {
        return UserDefaults(suiteName: TaskKillerGroupID.id)
    }()
    
    private lazy var possibleAdditionalWorkTimesForIds = loadPossibleAddtionalWorkTimes()
    
    private lazy var possibleBreakTimesForIds = loadPossibleBreakTimes()
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = .second
        formatter.unitsStyle = .full
        return formatter
    }()
    
    private var alarmReceivingDelegate: TaskAlarmsReceivingDelegate!
    private let notificationCenter = UNUserNotificationCenter.current()
    private let taskTimeOutNotificationRequestIdentifier = UUID().uuidString
    private let breakTimeOutNotificationRequestIdentifier = UUID().uuidString
    required init(alarmReceivingDelegate: TaskAlarmsReceivingDelegate) {
        self.alarmReceivingDelegate = alarmReceivingDelegate
        super.init()
        notificationCenter.delegate = self
    }
    
    //MARK: TaskAlarmControlling
    func addTaskTimeOutAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoSource) {
        let actions = createTaskTimeOutAlarmActions()
        let category = createCategory(from: actions, andIdentifier: CategoriesInfo.taskTimeOut.id)
        let content = createNotificationContentForTaskTimeOutAlarm(from: taskStaticInfoSource)
        content.categoryIdentifier = CategoriesInfo.taskTimeOut.id
        let trigger = createNotificationTrigger(from: timeInterval)
        notificationCenter.setNotificationCategories([category])
        let request = createNotificationRequest(withContent: content, trigger: trigger, andId: taskTimeOutNotificationRequestIdentifier)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    func addBreakTimeOutAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoSource) {
        let content = createNotificationContentForBreakIsOverAlarm(from: taskStaticInfoSource)
        content.categoryIdentifier = CategoriesInfo.breakTimeOut.id
        let trigger = createNotificationTrigger(from: timeInterval)
        
        let actions = createBreakTimeOutAlarmActions()
        let category = createCategory(from: actions, andIdentifier: CategoriesInfo.breakTimeOut.id)
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
        alarmReceivingDelegate.didReceiveAlarmInForeGround()
        completionHandler([.sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.notificationCategoryIdentifier {
        case CategoriesInfo.taskTimeOut.id: handleTaskTimeOutAlarmResponse(response)
        case CategoriesInfo.breakTimeOut.id: handleBreakTimeOutAlarmResponse(response)
        default: break
        }
        completionHandler()
    }
}
extension TaskAlarmsController: PossibleAdditionalTimesLoading {}

extension TaskAlarmsController {
    private func handleTaskTimeOutAlarmResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case let actionID where possibleBreakTimesForIds[actionID] != nil:
            let breakTime = possibleBreakTimesForIds[actionID]
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.needABreak(breakTime!))
        case let actionID where possibleAdditionalWorkTimesForIds[actionID] != nil:
            let postponeTime = possibleAdditionalWorkTimesForIds[actionID]
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.needMoreTime(postponeTime!))
        case CategoriesInfo.taskTimeOut.actionIDs.taskIsFinished:
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.finishTask)
        case UNNotificationDefaultActionIdentifier:
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.defaultAlarmResponse)
        case UNNotificationDismissActionIdentifier:
            alarmReceivingDelegate.didDismissAlarm()
        case CategoriesInfo.taskTimeOut.actionIDs.setWorkTimes:
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.noAdditionalTimesSet)
        default: break
        }
    }
    private func handleBreakTimeOutAlarmResponse(_ response: UNNotificationResponse) {
        switch response.actionIdentifier {
        case let actionID where possibleBreakTimesForIds[actionID] != nil:
            let breakTime = possibleBreakTimesForIds[actionID]
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.needABreak(breakTime!))
        case let actionID where possibleAdditionalWorkTimesForIds[actionID] != nil:
            let postponeTime = possibleAdditionalWorkTimesForIds[actionID]
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.needMoreTime(postponeTime!))
        case CategoriesInfo.taskTimeOut.actionIDs.taskIsFinished:
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.finishTask)
        case UNNotificationDefaultActionIdentifier:
            alarmReceivingDelegate.didReceiveAlarmWithResponseOfType(.defaultAlarmResponse)
        case UNNotificationDismissActionIdentifier:
            alarmReceivingDelegate.didDismissAlarm()
        default: break
        }
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
        let openApp = UNNotificationAction(identifier: CategoriesInfo.taskTimeOut.actionIDs.openApp, title: "Open App", options: [.foreground])
        let needBreak = UNNotificationAction(identifier: CategoriesInfo.taskTimeOut.actionIDs.needBreak, title: "I need a break", options: [])
        let needMoreTime = UNNotificationAction(identifier: CategoriesInfo.taskTimeOut.actionIDs.needMoreTime, title: "I need more time", options: [])
        let taskIsFinished = UNNotificationAction(identifier: CategoriesInfo.taskTimeOut.actionIDs.taskIsFinished, title: "I finished task", options: [.destructive])
        let actions = [needMoreTime, needBreak, taskIsFinished, openApp]
        return actions
    }
    
    
    private func createBreakTimeOutAlarmActions() -> [UNNotificationAction] {
        let openAppAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOut.actionIDs.openApp, title: "Open App", options: [.foreground])
        let needMoreBreakTimeAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOut.actionIDs.needBreak, title: "I need more break time", options: [])
        let getBackToTaskAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOut.actionIDs.getBackToTask, title: "Get back to task", options: [])
        let finishTaskAction = UNNotificationAction(identifier: CategoriesInfo.breakTimeOut.actionIDs.taskIsFinished, title: "Finish task", options: [])
        let actions = [getBackToTaskAction, needMoreBreakTimeAction, finishTaskAction, openAppAction]
        return actions
    }
    
    private func createCategory(from actions: [UNNotificationAction], andIdentifier identifier: String) -> UNNotificationCategory {
        let category = UNNotificationCategory(identifier: identifier, actions: actions, intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "You have action", options: [.customDismissAction])
        return category
    }
}


