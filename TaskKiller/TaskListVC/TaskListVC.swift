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
    private var fetchRequestController: NSFetchedResultsController<Task>!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequestController = createFetchResultsController()
    }
    
}
extension TaskListVC {
    private func createFetchResultsController() -> NSFetchedResultsController<Task> {
        let fetchResuest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchResuest.sortDescriptors = [sortDescriptor]
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchResuest, managedObjectContext: PersistanceService.context, sectionNameKeyPath: nil, cacheName: "TaskCache")
        guard let _ = try? fetchRequestController.performFetch() else { fatalError() }
        return fetchRequestController
    }
}
