//
//  AppDelegate.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 07.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
                // handle result
        })
        notificationCenter.getNotificationSettings(completionHandler: { (settings) in
            switch settings.authorizationStatus {
            case .denied: print("Notifications are disallowed")
            case .authorized: print("Notificaions are allowed")
            case .notDetermined: print("Not determined")
            case .provisional: print("Provisional")
            }
        })
        notificationCenter.getDeliveredNotifications(completionHandler: { (notifications) in
            for notification in notifications {
                print("Notification \(notification.request.content.body)")
            }
        })
        let possiblePostponeTimes: [String : TimeInterval] = [UUID().uuidString : 11, UUID().uuidString : 21, UUID().uuidString : 31]
        let possibleBreakTimes: [String : TimeInterval] = [UUID().uuidString : 12, UUID().uuidString : 22, UUID().uuidString : 32]
        let userDeafults = UserDefaults(suiteName: TaskKillerGroupID.id)
        userDeafults?.setValue(possiblePostponeTimes, forKey: UserDefaultsKeys.postponeTimesActionKeysAndValues)
        userDeafults?.setValue(possibleBreakTimes, forKey: UserDefaultsKeys.breakTimesActionKeysAndTimeValues)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is acodercan occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
            application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        PersistanceService.saveContext()
    }
}

