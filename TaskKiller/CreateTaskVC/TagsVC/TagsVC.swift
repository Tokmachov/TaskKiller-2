//
//  TagsVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class TagsVC: UICollectionViewController, DragInitiatingVC {
    
    //MARK: DragInitiatingVC
    func setDropAreaDelegate(_ delegate: DropAreaDelegate) {
        dropAreaDelegate = delegate
    }
    private weak var dropAreaDelegate: DropAreaDelegate!
    
    let distanceBetweenLines: CGFloat = 10
    let interItemSpacing: CGFloat = 10
    let spaceAroundTagsInCollectionView = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var indexOfEnlargedCell: IndexPath?
    private var changeIsUserDriven = false
    private var tagCellID = "Tag Cell"
    private var fetchResultsController: NSFetchedResultsController<TagModel>!
    private var collectionViewChangeContentsOperations = [BlockOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsController = createTagFetchResultsController()
        fetchResultsController.delegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellID)
        collectionView.backgroundColor = UIColor.red
        collectionView.dragDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
    }
}

extension TagsVC {
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
    private func alignTagModelOrderPropertyWithTagsOrderIn(_ tagModels: [TagModel]) {
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
extension TagsVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard !changeIsUserDriven else { return }
        switch type {
        case .insert:
            collectionViewChangeContentsOperations.append(
                BlockOperation(block: {
                    self.collectionView.insertItems(at: [newIndexPath!])
                })
            )
        case .update:
            collectionViewChangeContentsOperations.append(
                BlockOperation(block: {
                    self.collectionView.reloadItems(at: [indexPath!])
                })
            )
        case .move:
            collectionViewChangeContentsOperations.append(
                BlockOperation(block: {
                    self.collectionView.reloadItems(at: [indexPath!])
                })
            )
            collectionViewChangeContentsOperations.append(
                BlockOperation(block: {
                    self.collectionView.reloadItems(at: [newIndexPath!])
                })
            )
        default: break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if !changeIsUserDriven {
            for block in collectionViewChangeContentsOperations {
                block.start()
            }
            collectionViewChangeContentsOperations.removeAll()
        }
        
        changeIsUserDriven = false
        
    }
}
//MARK: UICollectionViewDataSource
extension TagsVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tagsLoadedFromMemory = fetchResultsController.fetchedObjects else { fatalError("Tags are not loaded from memory") }
        return tagsLoadedFromMemory.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellID, for: indexPath) as? TagCell else { fatalError() }
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = TagFactoryImp.createTag(from: tagModel)
        tagCell.setTagInfo(tag)
        if indexPath == indexOfEnlargedCell {
            tagCell.setSize(.large)
            return tagCell
        }
        tagCell.setSize(.normal)
        return tagCell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TagsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = TagFactoryImp.createTag(from: tagModel)
        let tagCell = TagCell(frame: CGRect.zero)
        tagCell.setTagInfo(tag)
        tagCell.setSize(.normal)
        if indexPath == indexOfEnlargedCell {
            tagCell.setSize(.large)
            return tagCell.getSizeNeededForContentView()
        }
        return tagCell.getSizeNeededForContentView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return distanceBetweenLines
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return spaceAroundTagsInCollectionView
    }
}

extension TagsVC {
    //MARK: DataSource Headers
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
            headerView.label.text = "These are tags"
        return headerView
        default: assert(false, "Unexpected element kind")
        
        }
    }
}

//MARK: UICollectionViewDelegate
extension TagsVC {
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        var indexPathsToReload = [IndexPath]()
        if let indexPathOfCellForDeenlarging = indexOfEnlargedCell { indexPathsToReload.append(indexPathOfCellForDeenlarging) }
        indexOfEnlargedCell = indexOfEnlargedCell != indexPath ? indexPath : nil
        if indexOfEnlargedCell != nil { indexPathsToReload.append(indexOfEnlargedCell!) }
        collectionView.reloadItems(at: indexPathsToReload)
        return false
    }
}

//MARK: UICollectionViewDragDelegate
extension TagsVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = TagFactoryImp.createTag(from: tagModel)
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tag
        return [dragItem]
    }
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        let parameters = UIDragPreviewParameters()
        parameters.backgroundColor = UIColor.clear
        return parameters
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        dropAreaDelegate.prepareDropArea()
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        dropAreaDelegate.dropAreaIsNoLongerNeeded()
    }
}

//MARK: UICollectionViewDropDelegate
extension TagsVC: UICollectionViewDropDelegate {

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
        let reorderedTags = reorderTags(in: fetchResultsController.fetchedObjects!, movingTagFrom: sourceIndexPath.row, to: destinationIndexPath.row)
        alignTagModelOrderPropertyWithTagsOrderIn(reorderedTags)
    }
}
