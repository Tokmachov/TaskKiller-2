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

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }
    func openApp() {
        extensionContext?.performNotificationDefaultAction()
    }
    
    func dismissNotification() {
        extensionContext?.dismissNotificationContentExtension()
    }
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
    }
    @IBAction func defaultButtonTapped(_ sender: UIButton) {
        openApp()
    }
}
