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
    
    private lazy var fetchRequestController: NSFetchedResultsController<TaskModel> = createFetchResultsController()
    private lazy var taskFactory: TaskFactory = TaskFactoryImp(tagFactory: TagFactoryImp())
    private lazy var taskListModelFactory: TaskListModelFactory = TaskListModelFactoryImp()
    private lazy var taskProgressModelFactory: TaskProgressModelFactory = TaskProgressModelFactoryImp()
    
    private var tagHeight: CGFloat {
        let heightReferenceTagLabel = TagLabel(frame: CGRect.zero)
        heightReferenceTagLabel.name = "SomeName"
        return heightReferenceTagLabel.intrinsicContentSize.height
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateTagCollectionViewsInTaskCells()
    }
    private func updateTagCollectionViewsInTaskCells() {
        guard let endIndex = fetchRequestController.fetchedObjects?.endIndex else { return }
        for index in 0..<endIndex {
            let indexPath = IndexPath(row: index, section: 0)
            guard let taskListCell = tableView.cellForRow(at: indexPath) as? TaskListCell else { return }
            taskListCell.tagsCollectionView.reloadData()
        }
    }
    //MARK:
    @IBAction func backFromTaskVC(segue: UIStoryboardSegue) {}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Continue Task"?:
            guard let indexPathOfSelectedRow = tableView.indexPathForSelectedRow else { fatalError() }
            let taskModel = fetchRequestController.object(at: indexPathOfSelectedRow)
            let task = taskFactory.makeTask(taskModel: taskModel)
            let taskProgressModel = taskProgressModelFactory.makeTaskProgressModel(task: task)
            let taskProgressVC = segue.destination as! TaskProgressVC
            taskProgressVC.model = taskProgressModel
        default: break
        }
    }
}

//MARK: NSFetchedResultsControllerDelegate
extension TaskListVC {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type:
        NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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

//MARK: TableViewDataSource
extension TaskListVC {
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
        let task = taskFactory.makeTask(taskModel: taskModel)
        let taskListModel = taskListModelFactory.makeTaskListModel(task: task)
        configure(taskListCell: taskCell, withTask: taskListModel, cellIndex: indexPath.row, tagCollectionHeight: tagHeight)
        return taskCell
    }
    
    private func configure(taskListCell: TaskListCell, withTask taskListModel: TaskListModel, cellIndex: Int, tagCollectionHeight: CGFloat) {
        taskListCell.taskDescription = taskListModel.taskDescription
        taskListCell.cellIndex = cellIndex
        taskListCell.adjustTagCollectionViewHeight(to: tagCollectionHeight)
    }
}
//MARK: TableViewDelegate
extension TaskListVC {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let task = fetchRequestController.object(at: indexPath)
            PersistanceService.context.delete(task)
            PersistanceService.saveContext()
        default: break
        }
    }
}
//MARK: TagsCollection dataSource, DelegateFlowLayout methods
extension TaskListVC: UICollectionViewDataSource, TagCellConfiguring, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellIndexPath = taskCellIndexPathOfTagCollectionView(collectionView)
        let taskModel = fetchRequestController.object(at: cellIndexPath)
        let task = taskFactory.makeTask(taskModel: taskModel)
        let taskListModel = taskListModelFactory.makeTaskListModel(task: task)
        return taskListModel.tagsStore.tagsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tag = tagForTagCollectionView(collectionView, toBeDisplayedAtCollectionViewIndexPath: indexPath)
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        configure(tagCell: tagCell, withTag: tag)
        return tagCell
    }
    private func tagForTagCollectionView(_ collectionView: UICollectionView, toBeDisplayedAtCollectionViewIndexPath indexPath: IndexPath) -> Tag {
        let cellIndexPath = taskCellIndexPathOfTagCollectionView(collectionView)
        let taskModel = fetchRequestController.object(at: cellIndexPath)
        let task = taskFactory.makeTask(taskModel: taskModel)
        let taskListModel = taskListModelFactory.makeTaskListModel(task: task)
        let tag = taskListModel.tagsStore.tag(at: indexPath.row)
        return tag
    }
    private func taskCellIndexPathOfTagCollectionView(_ collectionView: UICollectionView) -> IndexPath {
        return IndexPath(item: collectionView.tag, section: 0)
    }
}
