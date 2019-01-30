//
//  TaskTimeOutAlarmController.swift
//  TaskKiller
//
//  Created by mac on 30/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UserNotifications

struct TaskTimeOutAlarmController: TaskAlarmControlling {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let notificationRequestIdentifier = UUID().uuidString
    
    func addAlarmThatFiresIn(_ timeInterval: TimeInterval, forTask task: Task) {
        let content = createNotificationContentFromTask(task)
        let trigger = createNotificationTrigger(from: timeInterval)
        let request = createNotificationRequest(withContent: content, trigger: trigger, andId: notificationRequestIdentifier)
        notificationCenter.add(request, withCompletionHandler: nil)
    }
    private func createNotificationContentFromTask(_ task: Task) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "This is task time alarm"
        content.body = "Task time of \(task.getTaskDescription()) is up."
        return content
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
}
