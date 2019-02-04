//
//  TaskTimeOutAlarmController.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UserNotifications

class TaskTimeOutAlarmController: NSObject, TaskAlarmControlling, UNUserNotificationCenterDelegate {

    
    
    private var alarmReceivingDelegate: TaskTimeOutAlarmReceivingDelegate!
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationRequestIdentifier = UUID().uuidString
    
    required init(alarmReceivingDelegate: TaskTimeOutAlarmReceivingDelegate) {
        self.alarmReceivingDelegate = alarmReceivingDelegate
        super.init()
        notificationCenter.delegate = self
    }
    
    func addAlarmThatFiresIn(_ timeInterval: TimeInterval, alarmInfo taskStaticInfoSource: TaskStaticInfoCreating) {
        let content = createNotificationContentFromTaskStaticInfo(taskStaticInfoSource)
        let trigger = createNotificationTrigger(from: timeInterval)
        let request = createNotificationRequest(withContent: content, trigger: trigger, andId: notificationRequestIdentifier)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    private func createNotificationContentFromTaskStaticInfo(_ taskStaticInfoSource: TaskStaticInfoCreating) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "This is task time alarm"
        let taskDescription = getTaskDescriptionFrom(taskStaticInfoSource)
        content.body = "Task time of \(taskDescription) is up."
        return content
    }
    private func getTaskDescriptionFrom(_ taskStaticInoSource: TaskStaticInfoCreating) -> String {
        let taskStaticInfo = taskStaticInoSource.createStaticInfo()
        let taskDescription = taskStaticInfo.taskDescription
        return taskDescription
    }
    private func createNotificationTrigger(from timeInterval: TimeInterval) -> UNTimeIntervalNotificationTrigger {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        return trigger
    }
    private func createNotificationRequest(withContent content: UNMutableNotificationContent, trigger: UNTimeIntervalNotificationTrigger, andId id: String) -> UNNotificationRequest {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        return request
    }
    
    func removeAlarm() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationRequestIdentifier])
    }
    //MARK: UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        alarmReceivingDelegate.didReceiveTaskTimeOutAlarm()
    }
}
