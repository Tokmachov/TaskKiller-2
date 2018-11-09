//
//  GoalDescriptionVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TaskDescriptionVC: TaskDescriptionReporting {
    
    private var taskDescriptionReceiver: TaskDescriptionReceiving!
    
    func setTaskDescriptionReceiver(_ receiver: TaskDescriptionReceiving) {
        self.taskDescriptionReceiver = receiver
    }
}
