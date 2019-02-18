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
    
    
    
    private lazy var userDeafaults = {
        return UserDefaults(suiteName: AppGroupsID.taskKillerGroup)
    }()
    
    private lazy var possiblePostponeTimes: [String : TimeInterval] = {
        return userDeafaults?.dictionary(forKey: UserDefaultsKeys.postponeTimesActionKeysAndValues) as! [String : TimeInterval]
    }()
    
    private lazy var possibleBreakTimes: [String : TimeInterval] = {
        return userDeafaults?.dictionary(forKey: UserDefaultsKeys.breakTimesActionKeysAndTimeValues) as! [String : TimeInterval]
    }()
    
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

extension NotificationViewController {
    private func handleTaskTimeOutNotificationCategoryResponse(_ response: UNNotificationResponse, completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void ) {
        switch response.actionIdentifier {
        case CategoriesInfo.taskTimeOut.actionIDs.openApp:
            openApp()
            completion(.dismiss)
        case CategoriesInfo.taskTimeOut.actionIDs.needMoreTime:
            let actions = createNeedMoreTimeActionsFromPossiblePostponeTimes(possiblePostponeTimes)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.taskTimeOut.actionIDs.needBreak:
            let actions = createNeedABreakActionsFromPossibleBreakTimes(possibleBreakTimes)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.taskTimeOut.actionIDs.taskIsFinished:
            completion(.dismissAndForwardAction)
        case let actionID where possiblePostponeTimes[actionID] != nil || possibleBreakTimes[actionID] != nil:
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
            let actions = createNeedMoreTimeActionsFromPossiblePostponeTimes(possiblePostponeTimes)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.breakTimeOut.actionIDs.needBreak:
            let actions = createNeedABreakActionsFromPossibleBreakTimes(possibleBreakTimes)
            extensionContext?.notificationActions = actions
            completion(.doNotDismiss)
        case CategoriesInfo.breakTimeOut.actionIDs.taskIsFinished:
            completion(.dismissAndForwardAction)
        case let actionID where possiblePostponeTimes[actionID] != nil || possibleBreakTimes[actionID] != nil:
            completion(.dismissAndForwardAction)
        case UNNotificationDefaultActionIdentifier: completion(.dismissAndForwardAction)
        case UNNotificationDismissActionIdentifier: completion(.dismissAndForwardAction)
        default: dismissNotification()
        }
    }
    private func createNeedMoreTimeActionsFromPossiblePostponeTimes(_ times: [String : TimeInterval]) -> [UNNotificationAction] {
        var actions = [UNNotificationAction]()
        let orderedByTimesValueTimes = times.sorted { $1.value > $0.value }
        for (id, possiblePostponeTime) in orderedByTimesValueTimes {
            let actionIdentifier = id
            let actionTitle = createNeedMoreTimeActionTitleFromPostponeTime(possiblePostponeTime)
            let action = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
            actions.append(action)
        }
        return actions
    }
    private func createNeedMoreTimeActionTitleFromPostponeTime(_ time: TimeInterval) -> String {
        let restInMinutes = dateComponentsFormatter.string(from: time)
        return "Need \(restInMinutes ?? "Error") more"
    }
    private func createNeedABreakActionsFromPossibleBreakTimes(_ times: [String : TimeInterval]) -> [UNNotificationAction] {
        var actions = [UNNotificationAction]()
        let orderedByTimesValueTimes = times.sorted { $1.value > $0.value }
        for (id, possibleBreakTime) in orderedByTimesValueTimes {
            let actionIdentifier = id
            let actionTitle = createNeedABreakActionTitleFrom(possibleBreakTime)
            let action = UNNotificationAction(identifier: actionIdentifier, title: actionTitle, options: [])
            actions.append(action)
        }
        return actions
    }
    private func createNeedABreakActionTitleFrom(_ time: TimeInterval) -> String {
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
