//
//  NotificationViewController.swift
//  TaskExtension
//
//  Created by mac on 08/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationExtensionViewController: UIViewController, UNNotificationContentExtension {
    
    private lazy var workTimesWithActionIds = loadSwitchedOnWorkTimesWithIds()
    private lazy var breakTimesWithActionIds = loadSwitchedOnBreakTimesWithIds()
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    //MARK: UNNotificationContentExtension
    func didReceive(_ notification: UNNotification) {
        //Customise extension
    }
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        switch response.notificationCategoryIdentifier {
        case CategoriesInfo.taskTimeOutCategory.id: handleTaskTimeOutNotificationResponse(response, completion: completion)
        case CategoriesInfo.breakTimeOutCategory.id: handleBreakTimeOutNotificationResponse(response, completion: completion)
        default: dismissNotification()
        }
    }
}
extension NotificationExtensionViewController: SwitchedOnAdditionalTimesWithIdsLoading {}

extension NotificationExtensionViewController {
    
    private func handleTaskTimeOutNotificationResponse(_ response: UNNotificationResponse, completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void ) {
        switch response.actionIdentifier {
        case CategoriesInfo.taskTimeOutCategory.actionIDs.openApp:
            openApp()
            completion(.dismiss)
        case CategoriesInfo.taskTimeOutCategory.actionIDs.addWorkTime:
            let actions = createAddWorkTimeActions(from: workTimesWithActionIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.taskTimeOutCategory.actionIDs.addBreak:
            let actions = createAddBreakActions(from: breakTimesWithActionIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.taskTimeOutCategory.actionIDs.taskIsFinished:
            completion(.dismissAndForwardAction)
        case let id where isAddWorkTimeActionId(id) || isAddBreakTimeActionId(id):
            completion(.dismissAndForwardAction)
        case CategoriesInfo.taskTimeOutCategory.actionIDs.setWorkTimes:
            completion(.dismissAndForwardAction)
        case UNNotificationDefaultActionIdentifier: completion(.dismissAndForwardAction)
        case UNNotificationDismissActionIdentifier: completion(.dismissAndForwardAction)
        default: dismissNotification()
        }
    }
    private func handleBreakTimeOutNotificationResponse(_ response: UNNotificationResponse, completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void ) {
        switch response.actionIdentifier {
        case CategoriesInfo.breakTimeOutCategory.actionIDs.openApp:
            openApp()
            completion(.dismiss)
        case CategoriesInfo.breakTimeOutCategory.actionIDs.getBackToTask:
            let actions = createAddWorkTimeActions(from: workTimesWithActionIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.breakTimeOutCategory.actionIDs.needBreak:
            let actions = createAddBreakActions(from: breakTimesWithActionIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.breakTimeOutCategory.actionIDs.taskIsFinished:
            completion(.dismissAndForwardAction)
        case let id where isAddWorkTimeActionId(id) || isAddBreakTimeActionId(id):
            completion(.dismissAndForwardAction)
        case CategoriesInfo.breakTimeOutCategory.actionIDs.setBreakTimes:
            completion(.dismissAndForwardAction)
        case UNNotificationDefaultActionIdentifier: completion(.dismissAndForwardAction)
        case UNNotificationDismissActionIdentifier: completion(.dismissAndForwardAction)
        default: dismissNotification()
        }
    }
    private func isAddWorkTimeActionId(_ id: Id) -> Bool {
        return workTimesWithActionIds[id] != nil
    }
    private func isAddBreakTimeActionId(_ id: Id) -> Bool {
        return breakTimesWithActionIds[id] != nil
    }
    
    //MARK: createAddWorkTimeActions(from:)
    private func createAddWorkTimeActions(from switchedOnWorkTimes: [Id : AdditionalTimeValue]) -> [UNNotificationAction] {
        var actions = [UNNotificationAction]()
        guard !switchedOnWorkTimes.isEmpty else {
            let action = createNoWorkTimesSetAction()
            actions.append(action)
            return actions
        }
        let descendiniglySortedTimes = switchedOnWorkTimes.sorted { $0.value < $1.value }
        for (id, time) in descendiniglySortedTimes {
            let actionIdentifier = id
            let actionTitle = createAddWorkTimeActionTitle(from: time)
            let action = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
            actions.append(action)
        }
        return actions
    }
    private func createNoWorkTimesSetAction() -> UNNotificationAction {
        let actionTitle = "Установите значения дополнительного времени"
        let actionAdintifier = CategoriesInfo.taskTimeOutCategory.actionIDs.setWorkTimes
        return UNNotificationAction(identifier: actionAdintifier, title: actionTitle, options: [.foreground])
    }
    private func createAddWorkTimeActionTitle(from time: AdditionalTimeValue) -> String {
        let restInMinutes = dateComponentsFormatter.string(from: time)
        return "Необходимо \(restInMinutes ?? "Error")"
    }
    //MARK: createAddBreakActions(from:)
    private func createAddBreakActions(from switchOnBreakTimes: [Id : AdditionalTimeValue]) -> [UNNotificationAction] {
        var actions = [UNNotificationAction]()
        guard !switchOnBreakTimes.isEmpty else {
            let action = createNoBreakTimesSetAction()
            actions.append(action)
            return actions
        }
        let descendinglSortedTimes = switchOnBreakTimes.sorted { $0.value < $1.value }
        for (id, possibleBreakTime) in descendinglSortedTimes {
            let actionIdentifier = id
            let actionTitle = createAddBreakActionTitle(from: possibleBreakTime)
            let action = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
            actions.append(action)
        }
        return actions
    }
    private func createNoBreakTimesSetAction() -> UNNotificationAction {
        let actionTitle = "Установите значения дополнительного времени"
        let actionAdintifier = CategoriesInfo.breakTimeOutCategory.actionIDs.setBreakTimes
        return UNNotificationAction(identifier: actionAdintifier, title: actionTitle, options: [.foreground])
    }
    private func createAddBreakActionTitle(from time: AdditionalTimeValue) -> String {
        let timeStringRepresentation = dateComponentsFormatter.string(from: time)
        return "Отдых \(timeStringRepresentation ?? "Error")"
    }
    //MARK: openApp()
    private func openApp() {
        extensionContext?.performNotificationDefaultAction()
    }
    //MARK: dismissNotification()
    func dismissNotification() {
        extensionContext?.dismissNotificationContentExtension()
    }
}


