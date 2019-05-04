//
//  TaskStaticInfoDisplayingUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 12.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//
import UIKit

class TaskStaticInfoViewController: UIViewController  {
    var staticInfo: TaskStaticInfo! 
    private var tagsStore: ImmutableTagStore!
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .hour, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var taskInitialDeadlineLabel: UILabel!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var tagsCollectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var staticInfoStack: UIStackView!
    
    private var tagCollectionHeight: CGFloat {
        let tagLabel = TagLabel(frame: .zero)
        tagLabel.name = "Some name"
        let tagHeight = tagLabel.intrinsicContentSize.height
        return TaskProgressTagsCollectionFlowLayout.Constants.sectionInsets.top +
            TaskProgressTagsCollectionFlowLayout.Constants.sectionInsets.bottom +
        tagHeight
    }
    
    //MARK: ViewController lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStaticInfoViews()
        tagsCollectionViewHeightConstraint.constant = tagCollectionHeight
        reportSizeNeededForStaticInfoViewToPerentVC()
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        reportSizeNeededForStaticInfoViewToPerentVC()
    }
}

extension TaskStaticInfoViewController: UICollectionViewDataSource, TagCellConfiguring {
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

extension TaskStaticInfoViewController {
    private func updateStaticInfoViews() {
        taskDescriptionLabel.text = staticInfo.taskDescription
        taskInitialDeadlineLabel.text = formatter.string(from: staticInfo.initialDeadLine)
        tagsStore = staticInfo.tagsStore
    }
    private func reportSizeNeededForStaticInfoViewToPerentVC() {
        preferredContentSize = staticInfoStack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
