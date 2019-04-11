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
    
    private var taskListModelFactory: TaskListModelFactory!
    private var fetchRequestController: NSFetchedResultsController<TaskModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequestController = createFetchResultsController()
        taskListModelFactory = TaskListModelFactoryImp(taskFactory: TaskFactoryImp(tagFactory: TagFactoryImp()))
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
        let taskCell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskListCell
        let taskModel = fetchRequestController.object(at: indexPath)
        let task = taskListModelFactory.makeTaskListModel(taskModel: taskModel)
        configureTaskCell(taskCell, withTaskModel: task, andCellIndex: indexPath.row)
        return taskCell
    }
    private func configureTaskCell(_ cell: TaskListCell, withTaskModel model: TaskListModel, andCellIndex index: Int) {
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

//MARK: TagsCollection
extension TaskListVC: UICollectionViewDataSource, TagCellConfiguring {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellIndexPath = taskCellIndexPath(forTagCollectionView: collectionView)
        let taskModel = fetchRequestController.object(at: cellIndexPath)
        let task = taskListModelFactory.makeTaskListModel(taskModel: taskModel)
        return task.tagsStore.tagsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = tagForTagCollection(collectionView, toBeDisplayedAtCollectionViewIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        configure(tagCell: cell, withTag: tag)
        return cell
    }
}

extension TaskListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tagForTagCollection(collectionView, toBeDisplayedAtCollectionViewIndexPath: indexPath)
        let tagCell = TagCell(frame: CGRect.zero)
        configure(tagCell: tagCell, withTag: tag)
        return tagCell.getSizeNeededForContentView()
    }
}
extension TaskListVC {
    private func taskCellIndexPath(forTagCollectionView collectionView: UICollectionView) -> IndexPath {
        return IndexPath(item: collectionView.tag, section: 0)
    }
    private func tagForTagCollection(_ collectionView: UICollectionView, toBeDisplayedAtCollectionViewIndexPath indexPath: IndexPath) -> Tag {
        let cellIndexPath = taskCellIndexPath(forTagCollectionView: collectionView)
        let taskModel = fetchRequestController.object(at: cellIndexPath)
        let taskListModel = taskListModelFactory.makeTaskListModel(taskModel: taskModel)
        let tag = taskListModel.tagsStore.tag(at: indexPath.row)
        return tag
    }
}
