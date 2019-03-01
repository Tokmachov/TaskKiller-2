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

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    private lazy var userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
    
    private lazy var possibleAdditionalWorkTimesForIds = loadPossibleAddtionalWorkTimes()
    
    private lazy var possibleBreakTimesForIds = loadPossibleBreakTimes()
    
    private lazy var dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = .second
        formatter.unitsStyle = .full
        return formatter
    }()
    
    //MARK: UNNotificationContentExtension
    func didReceive(_ notification: UNNotification) {
        //Customise extension
    }
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        switch response.notificationCategoryIdentifier {
        case CategoriesInfo.taskTimeOut.id: handleTaskTimeOutNotificationCategoryResponse(response, completion: completion)
        case CategoriesInfo.breakTimeOut.id: handleBreakTimeOutNotificationCategoryResponse(response, completion: completion)
        default: dismissNotification()
        }
    }
}
extension NotificationViewController: PossibleAdditionalTimesLoading {}

extension NotificationViewController {
    
    private func handleTaskTimeOutNotificationCategoryResponse(_ response: UNNotificationResponse, completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void ) {
        switch response.actionIdentifier {
        case CategoriesInfo.taskTimeOut.actionIDs.openApp:
            openApp()
            completion(.dismiss)
        case CategoriesInfo.taskTimeOut.actionIDs.needMoreTime:
            let actions = createNeedMoreTimeActionsFromPossibleAdditionalWorkTimes(possibleAdditionalWorkTimesForIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.taskTimeOut.actionIDs.needBreak:
            let actions = createNeedABreakActionsFromPossibleBreakTimes(possibleBreakTimesForIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.taskTimeOut.actionIDs.taskIsFinished:
            completion(.dismissAndForwardAction)
        case let actionID where possibleAdditionalWorkTimesForIds[actionID] != nil || possibleBreakTimesForIds[actionID] != nil:
            completion(.dismissAndForwardAction)
        case CategoriesInfo.taskTimeOut.actionIDs.setWorkTimes:
            completion(.dismissAndForwardAction)
        case UNNotificationDefaultActionIdentifier: completion(.dismissAndForwardAction)
        case UNNotificationDismissActionIdentifier: completion(.dismissAndForwardAction)
        default: dismissNotification()
        }
    }
    private func handleBreakTimeOutNotificationCategoryResponse(_ response: UNNotificationResponse, completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void ) {
        switch response.actionIdentifier {
        case CategoriesInfo.breakTimeOut.actionIDs.openApp:
            openApp()
            completion(.dismiss)
        case CategoriesInfo.breakTimeOut.actionIDs.getBackToTask:
            let actions = createNeedMoreTimeActionsFromPossibleAdditionalWorkTimes(possibleAdditionalWorkTimesForIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.breakTimeOut.actionIDs.needBreak:
            let actions = createNeedABreakActionsFromPossibleBreakTimes(possibleBreakTimesForIds)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.breakTimeOut.actionIDs.taskIsFinished:
            completion(.dismissAndForwardAction)
        case let actionID where possibleBreakTimesForIds[actionID] != nil || possibleBreakTimesForIds[actionID] != nil:
            completion(.dismissAndForwardAction)
        case CategoriesInfo.breakTimeOut.actionIDs.setBreakTimes:
            completion(.dismissAndForwardAction)
        case UNNotificationDefaultActionIdentifier: completion(.dismissAndForwardAction)
        case UNNotificationDismissActionIdentifier: completion(.dismissAndForwardAction)
        default: dismissNotification()
        }
    }
    private func createNeedMoreTimeActionsFromPossibleAdditionalWorkTimes(_ times: [NotificationActionIdentifier : AdditionalTimeValue]) -> [UNNotificationAction] {
        var actions = [UNNotificationAction]()
        guard !times.isEmpty else {
            let action = createPleaseSetAdditionalWorkTimesAction()
            actions.append(action)
            return actions
        }
        let descendiniglySortedTimes = times.sorted { $0.value < $1.value }
        for (id, possibleAdditionalWorkTime) in descendiniglySortedTimes {
            let actionIdentifier = id
            let actionTitle = createNeedMoreTimeActionTitleFromAdditionalWorkTime(possibleAdditionalWorkTime)
            let action = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
            actions.append(action)
        }
        return actions
    }
    private func createPleaseSetAdditionalWorkTimesAction() -> UNNotificationAction {
        let actionTitle = "Please set Additional work times"
        let actionAdintifier = CategoriesInfo.taskTimeOut.actionIDs.setWorkTimes
        return UNNotificationAction(identifier: actionAdintifier, title: actionTitle, options: [.foreground])
    }
    private func createNeedMoreTimeActionTitleFromAdditionalWorkTime(_ time: AdditionalTimeValue) -> String {
        let restInMinutes = dateComponentsFormatter.string(from: time)
        return "Need \(restInMinutes ?? "Error") more"
    }
    private func createNeedABreakActionsFromPossibleBreakTimes(_ times: [NotificationActionIdentifier : AdditionalTimeValue]) -> [UNNotificationAction] {
        var actions = [UNNotificationAction]()
        guard !times.isEmpty else {
            let action = createPleaseSetBreakTimesAction()
            actions.append(action)
            return actions
        }
        let descendinglSortedTimes = times.sorted { $0.value < $1.value }
        for (id, possibleBreakTime) in descendinglSortedTimes {
            let actionIdentifier = id
            let actionTitle = createNeedABreakActionTitleFrom(possibleBreakTime)
            let action = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
            actions.append(action)
        }
        return actions
    }
    private func createPleaseSetBreakTimesAction() -> UNNotificationAction {
        let actionTitle = "Please set additional break times"
        let actionAdintifier = CategoriesInfo.breakTimeOut.actionIDs.setBreakTimes
        return UNNotificationAction(identifier: actionAdintifier, title: actionTitle, options: [.foreground])
    }
    private func createNeedABreakActionTitleFrom(_ time: AdditionalTimeValue) -> String {
        let timeStringRepresentation = dateComponentsFormatter.string(from: time)
        return "Need a break for \(timeStringRepresentation ?? "Error")"
    }
    
    private func openApp() {
        extensionContext?.performNotificationDefaultAction()
    }
    
    func dismissNotification() {
        extensionContext?.dismissNotificationContentExtension()
    }
}


