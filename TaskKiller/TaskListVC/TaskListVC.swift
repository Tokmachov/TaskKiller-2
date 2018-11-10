//
//  TaskListVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 09.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class TaskListVC: UITableViewController, NSFetchedResultsControllerDelegate {
    private var fetchRequestController: NSFetchedResultsController<Task>!
    private var taskStaticInfoUpdater: TaskStaticInfoUpdating!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequestController = createFetchResultsController()
        taskStaticInfoUpdater = TaskStaticInfoUpdater()
    }
    
    //MARK: TableViewDelegate, datasource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchRequestController.sections!.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchRequestController.sections else { fatalError() }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else { fatalError() }
        let taskObject = fetchRequestController.object(at: indexPath)
        let modelHandelerForTask = ModelHandler(task: taskObject)
        taskStaticInfoUpdater.update(taskCell, from: modelHandelerForTask)
        return taskCell
    }
}
extension TaskListVC {
    private func createFetchResultsController() -> NSFetchedResultsController<Task> {
        let fetchResuest: NSFetchRequest<Task> = Task.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchResuest.sortDescriptors = [sortDescriptor]
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchResuest, managedObjectContext: PersistanceService.context, sectionNameKeyPath: nil, cacheName: "TaskCache")
        guard let _ = try? fetchRequestController.performFetch() else { fatalError() }
        fetchRequestController.delegate = self
        return fetchRequestController
    }
}
