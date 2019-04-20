//
//  TagsAddedToTaskVC.swift
//  TaskKiller
//
//  Created by mac on 10/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagsAddedToTaskVC: UIViewController {
    
    private let maximumTagsAmount = 4

    //MARK: model
    private var tagsStore: TagsStore! {
        didSet {
            delegate.tagsAddedToTaskVCDidUpdateTags(self)
        }
    }
    var tagsAddedToTaskStore: ImmutableTagStore {
        return tagsStore
    }
    weak var delegate: TagsAddedToTaskVCDelegate!
    
    private var tagCollectionHeight: CGFloat {
        let tagLabel = TagLabel(frame: CGRect.zero)
        tagLabel.name = "Some name"
        let tagHeight = tagLabel.intrinsicContentSize.height
        return TagsAddedToTaskCollectionFlowLayout.Constants.sectionInsets.top +
               TagsAddedToTaskCollectionFlowLayout.Constants.sectionInsets.bottom +
               tagHeight
    }
    @IBOutlet weak var tagsAddedToTaskCollectionView: UICollectionView!
    
    //MARK: ViewController lyfe cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = TagsAddedToTaskCollectionFlowLayout()
        tagsAddedToTaskCollectionView.collectionViewLayout = layout
        tagsAddedToTaskCollectionView.dragInteractionEnabled = true
        tagsStore = TagStoreImp()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reportSizeNeededByCollectionViewToParentVC()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        reportSizeNeededByCollectionViewToParentVC()
        tagsAddedToTaskCollectionView.reloadData()
    }
    func removeFromTask(_ tag: Tag) {
        guard let index = tagsStore.index(Of: tag) else { return }
        let indexPathForTagToRemove = IndexPath(item: index, section: 0)
        tagsStore.remove(tag)
        tagsAddedToTaskCollectionView.deleteItems(at: [indexPathForTagToRemove])
    }
    func tagAddedToTaskWasUpdated(_ tag: Tag) {
        guard let indexOfTag = tagsStore.index(Of: tag) else { return }
        let indexPath = IndexPath(item: indexOfTag, section: 0)
        tagsAddedToTaskCollectionView.reloadItems(at: [indexPath])
    }
}

//MARK: CollectionViewDataSource
extension TagsAddedToTaskVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsStore.tagsCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tagCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
        let tag = tagsStore.tag(at: indexPath.row)
        configure(tagCell: tagCell, withTag: tag)
        return tagCell
    }
}

extension TagsAddedToTaskVC: TagCellConfiguring {}

//MARK: UICollectionViewDropDelegate
extension TagsAddedToTaskVC: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView.hasActiveDrag { return true }
        if let tag = session.provideLocalObject(ofType: Tag.self),
            tagsStore.tagsCount < maximumTagsAmount,
            tagsStore.canAdd(tag)
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
                tagsStore.remove(tag)
                tagsStore.insert(tag: tag, atIndex: destinationIndexPath.row)
                self.tagsAddedToTaskCollectionView.deleteItems(at: [sourceIndexPath])
                self.tagsAddedToTaskCollectionView.insertItems(at: [destinationIndexPath])
            }, completion: nil)
            return
        }
        coordinator.drop(dragItem, toItemAt: destinationIndexPath)
        tagsStore.insert(tag: tag, atIndex: destinationIndexPath.row)
        collectionView.insertItems(at: [destinationIndexPath])
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        delegate.tagsAddedToTaskVCDidBeginDrag(self)
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        delegate.tagsAddedToTaskVCDidEndDrag(self)
    }
}
//MARK: UICollectionViewDragDelegate
extension TagsAddedToTaskVC: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = tagsStore.tag(at: indexPath.row) as AnyObject
        return [dragItem]
    }
}

extension TagsAddedToTaskVC {
    private func reportSizeNeededByCollectionViewToParentVC() {
        let width = tagsAddedToTaskCollectionView.bounds.width
        preferredContentSize = CGSize(width: width, height: tagCollectionHeight)
    }
}
