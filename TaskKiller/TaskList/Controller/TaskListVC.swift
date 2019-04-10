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
    
    private var taskFactory: TaskListModelFactory!
    private var fetchRequestController: NSFetchedResultsController<TaskModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequestController = createFetchResultsController()
        taskFactory = TaskListImmutableModelFactoryImp(taskModelFetchResultsController: fetchRequestController, taskFactory: TaskFactoryImp())
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
        let task = taskFactory.makeTaskListModel(taskModelIndexPath: indexPath)
        configureTaskCell(taskCell, withTaskModel: task, andIndex: indexPath.row)
        return taskCell
    }
    private func configureTaskCell(_ cell: TaskCell, withTaskModel model: TaskListImmutableModel, andIndex index: Int) {
        cell.taskDescription = model.taskDescription
        cell.cellIndex = index
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let task = fetchRequestController.object(at: indexPath)
            PersistanceService.context.delete(task)
            PersistanceService.saveContext()
        default: break
        }
    }
    
    //MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: UITableView.RowAnimation.fade)
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    @IBAction func backFromTaskVC(segue: UIStoryboardSegue) {}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Continue Task"?:
            guard let indexPathOfSelectedRow = tableView.indexPathForSelectedRow else { fatalError() }
            let task = fetchRequestController.object(at: indexPathOfSelectedRow)
//            let taskModelFacade = taskFactory.makeTask(from: task)
//            let progressTrackingTaskHandler = TaskProgressSavingModelImp(task: taskModelFacade)
//            guard let taskVC = segue.destination as? TaskProgressTrackingVC else { fatalError() }
//            taskVC.setProgressTrackingTaskHandler(progressTrackingTaskHandler)
        default: break
        }
    }
}
extension TaskListVC {
    private func createFetchResultsController() -> NSFetchedResultsController<TaskModel> {
        let fetchResuest: NSFetchRequest<TaskModel> = TaskModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchResuest.sortDescriptors = [sortDescriptor]
        let fetchRequestController = NSFetchedResultsController(fetchRequest: fetchResuest, managedObjectContext: PersistanceService.context, sectionNameKeyPath: nil, cacheName: "TaskCache")
        guard let _ = try? fetchRequestController.performFetch() else { fatalError() }
        fetchRequestController.delegate = self
        return fetchRequestController
    }
}

extension TaskListVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let indexPath = IndexPath(item: collectionView.tag, section: section)
        let task = taskFactory.makeTaskListModel(taskModelIndexPath: indexPath)
        let tagsStore = task.tagsStore
        return tagsStore.tags.count
    }
}
