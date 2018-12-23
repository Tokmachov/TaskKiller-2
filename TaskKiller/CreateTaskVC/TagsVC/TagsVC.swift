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
    
    private var tagCellID = "Tag Cell"
    private var fetchResultsController: NSFetchedResultsController<TagModel>!
    private var collectionViewChangeContentsOperations = [BlockOperation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsController = createTagFetchResultsController()
        fetchResultsController.delegate = self
        
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: tagCellID)
        
        collectionView.backgroundColor = UIColor.red
    }
    
}

extension TagsVC {
    private func createTagFetchResultsController() -> NSFetchedResultsController<TagModel> {
        let fetchRequest: NSFetchRequest<TagModel> = TagModel.fetchRequest()
        let dateSort = NSSortDescriptor(key: "dateCreated", ascending: true)
        fetchRequest.sortDescriptors = [dateSort]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistanceService.context, sectionNameKeyPath: nil, cacheName: "TagsCache")
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("Failed to fetch entities")
        }
        return fetchResultsController
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
        return tagCell
    }
}

//MARK: NSFetchResultsControllerDelegate
extension TagsVC: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
        for block in collectionViewChangeContentsOperations {
            block.start()
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TagsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagModel = fetchResultsController.object(at: indexPath)
        let tag = TagFactoryImp.createTag(from: tagModel)
        let tagView = TagView(tag: tag)
        return tagView.getEstimatedTagViewSize()
    }
}
