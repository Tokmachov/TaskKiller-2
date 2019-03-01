//
//  AddTimesListVC.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class AddTimesListVC: UITableViewController, AdditionalTimeSavingDelegate {
    let cellId = "AdditionalTimeCell"
    let additionalWorkTimeSectionNumber = 0
    let breakTimeSectionNumber = 1
    
    private lazy var model: AdditionalTimes = loadAdditionalTimes()
    
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
        let state = getAdditionalTimeToggleState(sender)
        switch indexPath.section {
        case additionalWorkTimeSectionNumber: model.changeToggleStateOfAdditionalWorkTime(atIndex: indexPath.row, to: state)
        case breakTimeSectionNumber: model.changeToggleStateOfBreakTime(atIndex: indexPath.row, to: state)
        default: fatalError()
        }
        saveAdditionalTimes()
        savePossibleAdditionalTimes(model)
    }
    
    //MARK: CreateAdditionalTimesVCDelegate methods
    func additionalTimeWasCreated(_ additionalTime: AdditionalTime) {
        model.addAdditionalTime(additionalTime)
        saveAdditionalTimes()
        savePossibleAdditionalTimes(model)
    }
    
    //TableView Delegate methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.numberOfAdditionalTimesTypes
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case additionalWorkTimeSectionNumber: return model.additionalWorkTimes.count
        case breakTimeSectionNumber: return model.additionalBreakTimes.count
        default: return additionalWorkTimeSectionNumber
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UILabel()
        sectionHeader.backgroundColor = UIColor.gray
        switch section {
        case additionalWorkTimeSectionNumber:
            sectionHeader.setText(model.titleForAdditionalWorkTimesSection)
            return sectionHeader
        case breakTimeSectionNumber:
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
        case .delete where indexPath.section == additionalWorkTimeSectionNumber: model.removeAdditionalWorkTime(atIndex: indexPath.row)
        case .delete where indexPath.section == breakTimeSectionNumber: model.removeBreakTime(atIndex: indexPath.row)
        default: break
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveAdditionalTimes()
        savePossibleAdditionalTimes(model)
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
extension AddTimesListVC: PossibleAdditionalTimesSaving {}
extension AddTimesListVC: AdditionalTimesLoading {}
extension AddTimesListVC {
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
        case additionalWorkTimeSectionNumber: additionalTime = additionalTimes.additionalWorkTimes[indexPath.row]
        case breakTimeSectionNumber: additionalTime = additionalTimes.additionalBreakTimes[indexPath.row]
        default: fatalError()
        }
        return additionalTime
    }
    
//    //MARK: loadAdditionaTimes()
//    private func loadAdditionaTimes() -> AdditionalTimes {
//        guard let data = loadAdditionalTimesDataFromUserDefaults() else { return AdditionalTimes() }
//        guard let additionalTimes = unarchiveAdditionalTimesData(data) else { fatalError() }
//        return additionalTimes
//    }
//    private func loadAdditionalTimesDataFromUserDefaults() -> Data? {
//        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
//        let additionalTimesData = userDefaults?.data(forKey: UserDefaultsKeys.additionalTimesKey)
//        return additionalTimesData
//    }
//    private func unarchiveAdditionalTimesData(_ data: Data) -> AdditionalTimes? {
//        let additionalTimes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AdditionalTimes
//        return additionalTimes!
//    }
    //MARK: saveAdditionalTimes()
    private func saveAdditionalTimes() {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: model, requiringSecureCoding: false)
        let userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
        userDefaults?.set(data, forKey: UserDefaultsKeys.additionalTimesKey)
    }
   
    //MARK: customizeNavigationBar()
    private func customizeNavigationBar() {
        navigationItem.title = "Add times"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getAdditionalTimeToggleState(_ sender: UISwitch) -> ToggleState {
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

