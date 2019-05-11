//
//  TagsVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class AvailableTagsVC: UIViewController {
    
    //MARK: Factrory
    private var tagFactory = TagFactoryImp()
    
    //MARK: Delegate
    weak var delegate: AvailableTagsVCDelegate!
    
    //MARK: content height
    var heightOfContent: CGFloat {
        return tagsCollectionView.contentSize.height
    }
    
    //MARK: FetchResultsController
    private var fetchResultsController: NSFetchedResultsController<TagModel>!
    
    //MARK: Outlets
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsController = createTagFetchResultsController()
        fetchResultsController.delegate = self
        tagsCollectionView.dragInteractionEnabled = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            alignTagModelsOrderPropertyWithTagsOrderIn(fetchResultsController.fetchedObjects!)
    }
    
    //MARK: TraitCollectionDidChange
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tagsCollectionView.reloadData()
    }
}

extension AvailableTagsVC {
    private func createTagFetchResultsController() -> NSFetchedResultsController<TagModel> {
        let fetchRequest: NSFetchRequest<TagModel> = TagModel.fetchRequest()
        let orderSort = NSSortDescriptor(key: "positionInUserSelectedOrder", ascending: true)
        fetchRequest.sortDescriptors = [orderSort]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistanceService.context, sectionNameKeyPath: nil, cacheName: "TagsCache")
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities")
        }
        return fetchResultsController
    }
    private func alignTagModelsOrderPropertyWithTagsOrderIn(_ tagModels: [TagModel]) {
        for (i, tagModel) in tagModels.enumerated() {
            tagModel.positionInUserSelectedOrder = Int16(i)
        }
        PersistanceService.saveContext()
    }
    
    private func reorderTags(in tags: [TagModel], movingTagFrom sourcePosition: Int, to destination: Int) -> [TagModel] {
        var reorderedTags = tags
        let tagToMove = reorderedTags[sourcePosition]
        reorderedTags.remove(at: sourcePosition)
        reorderedTags.insert(tagToMove, at: destination)
        return reorderedTags
    }
}
//MARK: NSFetchResultsControllerDelegate
extension AvailableTagsVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tagsCollectionView.insertItems(at: [newIndexPath!])
        case .delete:
            tagsCollectionView.deleteItems(at: [indexPath!])
        case .update: tagsCollectionView.reloadItems(at: [indexPath!])
        default: break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
//MARK: UICollectionViewDataSource
extension AvailableTagsVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tagsLoadedFromMemory = fetchResultsController.fetchedObjects else { fatalError("Tags are not loaded from memory") }
        return tagsLoadedFromMemory.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = tagFactory.makeTag(tagModel: tagModel)
        configure(tagCell: tagCell, withTag: tag)
        return tagCell
    }
}

//MARK: UICollectionViewDelegateFlowlayout
extension AvailableTagsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagView = TagLabel()
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = tagFactory.makeTag(tagModel: tagModel)
        tagView.name = tag.name
        return tagView.intrinsicContentSize
    }
}

extension AvailableTagsVC: TagCellConfiguring {}

//MARK: UICollectionViewDragDelegate
extension AvailableTagsVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = tagFactory.makeTag(tagModel: tagModel)
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tag as AnyObject
        return [dragItem]
    }
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        return parameters
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        delegate.availableTagsVCDidBegingDrag(self)
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        delegate.availableTagsVCDidEndDrag(self)
    }
}

//MARK: UICollectionViewDropDelegate
extension AvailableTagsVC: UICollectionViewDropDelegate {

    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        guard collectionView.hasActiveDrag else { return false }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let dropProposal = UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        return dropProposal
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let item = coordinator.items.first!
        guard let sourceIndexPath = item.sourceIndexPath else { return }
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        collectionView.performBatchUpdates({
            let reorderedTags = reorderTags(in: fetchResultsController.fetchedObjects!, movingTagFrom: sourceIndexPath.row, to: destinationIndexPath.row)
            alignTagModelsOrderPropertyWithTagsOrderIn(reorderedTags)
            collectionView.deleteItems(at: [sourceIndexPath])
            collectionView.insertItems(at: [destinationIndexPath])
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }, completion: nil)
    }
}
