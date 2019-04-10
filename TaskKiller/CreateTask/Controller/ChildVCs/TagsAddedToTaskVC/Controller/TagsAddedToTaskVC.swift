//
//  TagsAddedToTaskVC.swift
//  TaskKiller
//
//  Created by mac on 10/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagsAddedToTaskVC: UICollectionViewController {
    
    private let maximumTagsAmount = 4

    //MARK: model
    private var tagsAddedToTaskStore: TagsStore! {
        didSet {
            delegate.tagsAddedToTaskWereUpdated(in: self)
        }
    }
    var tagsAddedToTask: ImmutableTagStore {
        return tagsAddedToTaskStore
    }
    weak var delegate: TagsAddedToTaskVCDelegate!
    
    func removeFromTask(_ tag: Tag) {
        guard let index = tagsAddedToTaskStore.index(Of: tag) else { return }
        let indexPathForTagToRemove = IndexPath(item: index, section: 0)
        tagsAddedToTaskStore.remove(tag)
        collectionView.deleteItems(at: [indexPathForTagToRemove])
    }
    func tagAddedToTaskWasUpdated(_ tag: Tag) {
        guard let indexOfTag = tagsAddedToTaskStore.index(Of: tag) else { return }
        let indexPath = IndexPath(item: indexOfTag, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
        collectionView.dragInteractionEnabled = true
        tagsAddedToTaskStore = TagStoreImp()
    }
}

//MARK: CollectionViewDataSource
extension TagsAddedToTaskVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsAddedToTaskStore.tagsCount
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = tagsAddedToTaskStore.tag(at: indexPath.row)
        configure(tagCell: tagCell, withTag: tag)
        return tagCell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TagsAddedToTaskVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagCell = TagCell(frame: CGRect.zero)
        let tag = tagsAddedToTaskStore.tag(at: indexPath.row)
        configure(tagCell: tagCell, withTag: tag)
        
        return tagCell.getSizeNeededForContentView()
    }
}

extension TagsAddedToTaskVC: TagCellConfiguring {}

//MARK: UICollectionViewDropDelegate
extension TagsAddedToTaskVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView.hasActiveDrag { return true }
        if let tag = session.provideLocalObject(ofType: Tag.self),
            tagsAddedToTaskStore.tagsCount < maximumTagsAmount,
            tagsAddedToTaskStore.canAdd(tag)
            { return true }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            let dropProposal = UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            return dropProposal
        } else {
            let dropProposal = UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            return dropProposal
        }
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        guard let tag = coordinator.session.provideLocalObject(ofType: Tag.self),
            let dragItem = coordinator.session.items.first else { return }
        
        if collectionView.hasActiveDrag, let sourceIndexPath = coordinator.items.first?.sourceIndexPath {
            collectionView.performBatchUpdates({
                coordinator.drop(dragItem, toItemAt: destinationIndexPath)
                tagsAddedToTaskStore.remove(tag)
                tagsAddedToTaskStore.insert(tag: tag, atIndex: destinationIndexPath.row)
                self.collectionView.deleteItems(at: [sourceIndexPath])
                self.collectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            return
        }
        coordinator.drop(dragItem, toItemAt: destinationIndexPath)
        tagsAddedToTaskStore.insert(tag: tag, atIndex: destinationIndexPath.row)
        collectionView.insertItems(at: [destinationIndexPath])
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        delegate.addDropAreaForRemovingTagFromTask(for: self)
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        delegate.removeDropAreaForRemovingTagFromTask(for: self)
    }
}
//MARK: UICollectionViewDragDelegate
extension TagsAddedToTaskVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tagsAddedToTaskStore.tag(at: indexPath.row) as AnyObject
        return [dragItem]
    }
}

