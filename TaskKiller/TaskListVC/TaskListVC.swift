//
//  TaskListVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 09.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class TaskListVC: UITableViewController {
    private var fetchRequestController: NSFetchedResultsController!

}
extension TaskListVC {
    private func createFetchResultsController -> NSFetchedResultsController {
        let fetchResuest: NSFetchRequest<Task> = Task.fetchRequest()
        //let sortDescriptor = NSSortDescriptor(
    }
}
