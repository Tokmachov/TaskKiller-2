//
//  TagsVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

class TagsVC: UICollectionViewController {
    
    let distanceBetweenLines: CGFloat = 10
    let interItemSpacing: CGFloat = 10
    let spaceAroundTagsInCollectionView = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var longTapGestureRecognizer: UILongPressGestureRecognizer!
    
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
        longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longTapGestureRecognizer)
    }
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
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
            tagCell.changeSizeToLarge()
            return tagCell
        }
        tagCell.changeSizeToNormal()
        return tagCell
    }
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("Start index \(sourceIndexPath)")
        var tagModels = fetchResultsController.fetchedObjects!
        let tagToMove = tagModels[sourceIndexPath.row]
        tagModels.remove(at: sourceIndexPath.row)
        tagModels.insert(tagToMove, at: destinationIndexPath.row)
        alignTagModelOrderPropertyWithTagsOrderIn(tagModels)
        changeIsUserDriven = true
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TagsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = TagFactoryImp.createTag(from: tagModel)
        let tagCell = TagCell(frame: CGRect.zero)
        tagCell.setTagInfo(tag)
        if indexPath == indexOfEnlargedCell {
            tagCell.changeSizeToLarge()
            return tagCell.getSizeNeededForItsView()
        }
        tagCell.changeSizeToNormal()
        return tagCell.getSizeNeededForItsView()
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
            headerView.label.text = "This are tags"
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
