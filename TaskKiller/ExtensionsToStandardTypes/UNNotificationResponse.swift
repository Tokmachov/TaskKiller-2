//
//  UNNotificationResponse.swift
//  TaskKiller
//
//  Created by mac on 17/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UserNotifications

extension UNNotificationResponse {
    var notificationCategoryIdentifier: String {
        get {
            return self.notification.request.content.categoryIdentifier
        }
    }
}
