//
//  AddTimesListVC.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class AdditionalTimesTableViewController: UITableViewController, AdditionalTimeSavingDelegate {
    let cellId = "AdditionalTimeCell"
    let workTimesSectionNumber = 0
    let breakTimesSectionNumber = 1
    
    private lazy var model: TimesModelForTable = loadAdditionalTimes()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBAction func additionalTimeStateWasSwitched(_ sender: UISwitch) {
        let indexPath = getCellIndexPath(of: sender)
        let state = getTimeToggleState(sender)
        switch indexPath.section {
        case workTimesSectionNumber: model.changeToggleStateOfWorkTime(atIndex: indexPath.row, to: state)
        case breakTimesSectionNumber: model.changeToggleStateOfBreakTime(atIndex: indexPath.row, to: state)
        default: fatalError()
        }
        saveAdditionalTimes(model)
        saveSwitchedOnAdditionalTimesWithIds(from: model)
    }
    
    //MARK: CreateAdditionalTimesVCDelegate methods
    func additionalTimeWasCreated(_ additionalTime: AdditionalTime) {
        model.addAdditionalTime(additionalTime)
        saveAdditionalTimes(model)
        saveSwitchedOnAdditionalTimesWithIds(from: model)
    }
    
    //TableView Delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfAdditionalTimesTypes
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case workTimesSectionNumber: return model.additionalWorkTimes.count
        case breakTimesSectionNumber: return model.additionalBreakTimes.count
        default: return workTimesSectionNumber
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UILabel()
        sectionHeader.backgroundColor = UIColor.gray
        switch section {
        case workTimesSectionNumber:
            sectionHeader.setText(model.titleForAdditionalWorkTimesSection)
            return sectionHeader
        case breakTimesSectionNumber:
            sectionHeader.setText(model.titleForAdditionalBreakTimesSection)
            return sectionHeader
        default: fatalError()
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AdditionalTimeCell
        configureCell(cell: cell, atIndexPath: indexPath, from: model)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete where indexPath.section == workTimesSectionNumber: model.removeWorkTime(atIndex: indexPath.row)
        case .delete where indexPath.section == breakTimesSectionNumber: model.removeBreakTime(atIndex: indexPath.row)
        default: break
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveAdditionalTimes(model)
        saveSwitchedOnAdditionalTimesWithIds(from: model)
    }
    //Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CreateAdditionalTimeSegue":
            var destinationVC = segue.destination as! AdditionalTimeCreating
            destinationVC.delegate = self
        default: fatalError()
        }
    }
}
extension AdditionalTimesTableViewController: SwitchedOnAdditionalTimesWithIdsSaving {}
extension AdditionalTimesTableViewController: AdditionalTimesLoading {}
extension AdditionalTimesTableViewController: AdditionalTimesSaving {}

extension AdditionalTimesTableViewController {
    //MARK: configureCell(cell:, atIndexPath:, from:)
    private func configureCell(cell: AdditionalTimeCell, atIndexPath indexPath: IndexPath, from additionalTimes: AdditionalTimes) {
        let additionalTime = getAdditionalTime(from: additionalTimes, forIndexPath: indexPath)
        
        let time = additionalTime.time
        let toggleState = additionalTime.toggleState

        cell.setTime(time)
        cell.setToggleState(toggleState)
    }
    private func getAdditionalTime(from additionalTimes: AdditionalTimes, forIndexPath indexPath: IndexPath) -> AdditionalTime {
        let validSectionsRange = 0...2
        guard validSectionsRange.contains(indexPath.section) else { fatalError() }
        
        let additionalTime: AdditionalTime
        switch indexPath.section {
        case workTimesSectionNumber: additionalTime = additionalTimes.additionalWorkTimes[indexPath.row]
        case breakTimesSectionNumber: additionalTime = additionalTimes.additionalBreakTimes[indexPath.row]
        default: fatalError()
        }
        return additionalTime
    }
    
    //MARK: customizeNavigationBar()
    private func customizeNavigationBar() {
        navigationItem.title = "Add times"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getTimeToggleState(_ sender: UISwitch) -> ToggleState {
        switch sender.isOn {
        case true: return ToggleState.on
        case false: return ToggleState.off
        }
    }
    private func getCell(of sender: UISwitch) -> AdditionalTimeCell {
        let cellsContentView = sender.superview!
        let cell = cellsContentView.superview as! AdditionalTimeCell
        return cell
    }
    private func getCellIndexPath(of sender: UISwitch) -> IndexPath {
        let cell = getCell(of: sender)
        let indexPath = tableView.indexPath(for: cell)!
        return indexPath
    }

}

