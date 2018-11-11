//
//  TaskVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 11.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit


class TaskVC: UIViewController, TaskProgressTracking  {
    
    private var taskProgressTracker: TaskProgressTrackingModelHandler!
    
    //MARK: TaskProgressTracking
    func setTaskProgressTracker(_ tracker: TaskProgressTrackingModelHandler) {
        self.taskProgressTracker = tracker
    }

}
