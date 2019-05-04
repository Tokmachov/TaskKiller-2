//
//  CalendarVC.swift
//  TaskKiller
//
//  Created by mac on 05/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private lazy var monthStore: MonthsStore = MonthsModelsStoreFactory.makeMonthModelsStore(startYear: 2018, endYear: 2019)
    private lazy var calendarViewsSizes: CalendarViewsSizes = {
       return CalendarViewsSizes(
        referenceValue: collectionView.bounds.width,
        verticalDaysRowsCount: monthStore.maximumWeekCountInAllMonths
        )
    }()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var weekDaysStack: UIStackView!
    @IBOutlet weak var leftWeekDaysInset: NSLayoutConstraint!
    @IBOutlet weak var rightWeekDaysInset: NSLayoutConstraint!
    @IBOutlet weak var monthAndYearLabel: UILabel!
    override func viewDidLoad() {
        fillWeekDaysNames()
        setWeekDaysViewInsets()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustCollectionViewHeight()
    }
}
//MARK: CollectionViewDataSource
extension CalendarVC {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthStore.monthCount
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfDays = monthStore.month(atIndex: section).daysCount
        return numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! DayCell
        let dayModel = monthStore.month(atIndex: indexPath.section).day(atIndex: indexPath.row)
        cell.update(with: dayModel)
        
        return cell
    }

}
//MARK: CollectionViewDelegateFlowLayout
extension CalendarVC {
    //paddings
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let leftPadding = calendarViewsSizes.leftSidePadding
        let rightPadding = calendarViewsSizes.rightSidePadding
        let topPadding = calendarViewsSizes.topPadding
        let daysRowPlaceholdersCount = monthStore.maximumWeekCountInAllMonths - monthStore.weekCountInMonth(atIndex: section)
        let bottomPadding = calendarViewsSizes.bottomPadding(numberOfDaysRowPlaceHolders: daysRowPlaceholdersCount)
        let insets = UIEdgeInsets(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)
        return insets
    }
    // between days horisontal
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return calendarViewsSizes.betweenDaysVerticalSpacing
    }
    // between days vertical
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let betweenDaysVerticalSpacing = calendarViewsSizes.betweenDaysHorisontalSpacing
        return betweenDaysVerticalSpacing
    }
    // day width height
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return calendarViewsSizes.daysSize
    }
}
//MARK: UIScrollViewDelegate
extension CalendarVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = visibleSectionNumber()
        let description = monthStore.month(atIndex: index).description
        monthAndYearLabel.text = description
    }
    private func visibleSectionNumber()-> Int {
        let sectionNumbers =  collectionView.indexPathsForVisibleItems.map { $0.section }
        typealias SectionNumber = Int
        typealias SectionsCount = Int
        var sections = [SectionNumber : SectionsCount]()
        for sectionNumber in sectionNumbers {
            sections[sectionNumber] = sections[sectionNumber] != nil ? sections[sectionNumber]! + 1 : 1
        }
        return sections.max { $0.value > $1.value }!.key
    }
}

extension CalendarVC {
    private func fillWeekDaysNames() {
        let weekDaySymbols = Calendar.current.shortWeekdaySymbols
        for (index, weekDaySybol) in weekDaySymbols.enumerated() {
            let weekDayLabel = weekDaysStack.arrangedSubviews[index] as? UILabel
            weekDayLabel!.text = weekDaySybol
        }
    }
    private func setWeekDaysViewInsets() {
        leftWeekDaysInset.constant = calendarViewsSizes.leftSidePadding
        rightWeekDaysInset.constant = -calendarViewsSizes.rightSidePadding
        weekDaysStack.spacing = calendarViewsSizes.betweenDaysHorisontalSpacing
    }
    private func adjustCollectionViewHeight() {
        let height = calendarViewsSizes.calculatedHeight
        collectionViewHeight.constant = height
    }
}

struct CalendarViewsSizes {
    private var referenceValue: CGFloat
    private var verticalDaysRowsCount: CGFloat
    init(referenceValue: CGFloat, verticalDaysRowsCount: Int) {
        self.referenceValue = referenceValue
        self.verticalDaysRowsCount = CGFloat(verticalDaysRowsCount)
    }
    
    private let totalDaysWidthsRatio: CGFloat = 0.69
    private let daysHorisontalCount: CGFloat = 7
    private let topPaddingRatio: CGFloat = 0.03
    private let bottomPaddingRatio: CGFloat = 0.03
    private let sidePaddingsPortionInTotalHorisontalSpacingsLength: CGFloat = 0.3

    var daysSize: CGSize {
        let daySide = totalDaysWidth / daysHorisontalCount
        let daysSize = CGSize(width: daySide, height: daySide)
        return daysSize
    }
    
    var leftSidePadding: CGFloat {
        let totalHorisontalSpacingsLength = referenceValue - (daysSize.width * daysHorisontalCount)
        let totalPaddingsLength = sidePaddingsPortionInTotalHorisontalSpacingsLength * totalHorisontalSpacingsLength
        return totalPaddingsLength / 2
    }
    var rightSidePadding: CGFloat {
        return leftSidePadding
    }
    var topPadding: CGFloat {
        return referenceValue * topPaddingRatio
    }
    func bottomPadding(numberOfDaysRowPlaceHolders: Int) -> CGFloat {
        return bottomPaddingWithoutDaysRowPlaceHolders + CGFloat(numberOfDaysRowPlaceHolders) * daysRowPlaceholderHeight
    }
    
    var betweenDaysHorisontalSpacing: CGFloat {
        let totalBetweenDaysSpacingsLength = referenceValue - (daysSize.width * daysHorisontalCount) - leftSidePadding - rightSidePadding
        let betweenDaysSpacingsCount = daysHorisontalCount - 1
        return totalBetweenDaysSpacingsLength / betweenDaysSpacingsCount
    }
    var betweenDaysVerticalSpacing: CGFloat {
        return betweenDaysHorisontalSpacing
    }
    var calculatedHeight: CGFloat {
        return verticalDaysRowsCount * daysRowPlaceholderHeight + topPadding + bottomPaddingWithoutDaysRowPlaceHolders
    }
    private var totalDaysWidth: CGFloat {
        return referenceValue * totalDaysWidthsRatio
    }
    private var bottomPaddingWithoutDaysRowPlaceHolders: CGFloat {
        return referenceValue * bottomPaddingRatio
    }
    private var daysRowPlaceholderHeight: CGFloat {
        return daysSize.height + betweenDaysVerticalSpacing
    }

}
