//
//  TagsAddedToTaskVC.swift
//  TaskKiller
//
//  Created by mac on 10/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagsAddedToTaskVC: UICollectionViewController, TagsForTaskPreparing {
    
    private let maximumTagsAmount = 3
    
    private let distanceBetweenLines: CGFloat = 10
    private let interItemSpacing: CGFloat = 10
    private let spaceAroundTagsInCollectionView = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var tagsAddedToTask: TagsStore = TagStoreImp()
    
    private weak var delegate: TagRemovingFromTaskDropAreaPreparingDelegate!
    //MARK: TagsForTaskPreparing
    func setDelegate(_ delegate: TagRemovingFromTaskDropAreaPreparingDelegate) {
        self.delegate = delegate
    }
    func removeFromTask(_ tag: Tag) {
        guard let index = tagsAddedToTask.index(Of: tag) else { return }
        let indexPathForTagToRemove = IndexPath(item: index, section: 0)
        tagsAddedToTask.remove(tag)
        collectionView.deleteItems(at: [indexPathForTagToRemove])
    }
    func tagAddedToTaskWasUpdated(_ tag: Tag) {
        guard let indexOfTag = tagsAddedToTask.index(Of: tag) else { return }
        let indexPath = IndexPath(item: indexOfTag, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
    func getTagsAddedToTaskStore() -> AllTagsGetableStore {
        return tagsAddedToTask
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.green
        collectionView.alwaysBounceVertical = true
        collectionView.dragInteractionEnabled = true
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
    }
}

//MARK: CollectionViewDataSource
extension TagsAddedToTaskVC {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsAddedToTask.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = tagsAddedToTask.tag(at: indexPath.row)
        tagCell.setTagInfo(tag)
        return tagCell
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension TagsAddedToTaskVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagCell = TagCell(frame: CGRect.zero)
        let tag = tagsAddedToTask.tag(at: indexPath.row)
        tagCell.setTagInfo(tag)
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

//MARK: UICollectionViewDropDelegate
extension TagsAddedToTaskVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        guard !collectionView.hasActiveDrag else { return true }
        guard let tag = session.provideLocalObject(ofType: Tag.self),
            tagsAddedToTask.count < maximumTagsAmount,
            tagsAddedToTask.canAdd(tag)
        else { return false }
        return true
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if collectionView.hasActiveDrag {
            guard let sourceIndexOfMovedTag = coordinator.items.first?.sourceIndexPath else { return }
            guard let destinationIndexOfMovedTag = coordinator.destinationIndexPath else { return }
            tagsAddedToTask.move(from: sourceIndexOfMovedTag.row, to: destinationIndexOfMovedTag.row)
            collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: [sourceIndexOfMovedTag])
                self.collectionView.insertItems(at: [destinationIndexOfMovedTag])
            }, completion: nil)
            return
        }
        guard let tag = (coordinator.items.first?.dragItem.localObject as AnyObject) as? Tag else { return }
        tagsAddedToTask.add(tag)
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        delegate.prepareTagRemovingFromAllTaskDropArea()
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        delegate.removeTagRemovingFromAllTagsDropArea()
    }
}

extension TagsAddedToTaskVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tagsAddedToTask.tag(at: indexPath.row) as AnyObject
        return [dragItem]
    }
}

