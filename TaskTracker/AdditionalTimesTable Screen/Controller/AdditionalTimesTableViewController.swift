//
//  AddTimesListVC.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class AdditionalTimesTableViewController: UITableViewController,
    CreateAdditionalTimeVCDelegate,
    SwitchedOnAdditionalTimesWithIdsSaving
{
    let cellId = "AdditionalTimeCell"
    
    //MARK: Model
    private var additionalTimesStore: AdditionalTimesStore {
        get {
            return tableViewModelController.additionalTimesStore
        }
    }
    private lazy var tableViewModelController: AdditionalTimesTableViewModelController = {
       let additionalTimesStore = loadAdditionalTimes()
        return AdditionalTimesTableViewModelController(additionalTimesStore: additionalTimesStore)
    }()
    
    //MARK: ViewController lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: Action methods
    @IBAction func additionalTimeStateWasSwitched(_ sender: UISwitch) {
        let indexPath = getCellIndexPath(of: sender)
        let state = getTimeToggleState(sender)
        tableViewModelController.changeToggleStateOfAdditionalTime(atIndexPath: indexPath, newTogglesState: state)
        saveAdditionalTimes(additionalTimesStore)
        let workTimes = getSwitchedOnAdditionalWorkTimesAndIds()
        let breakTimes = getSwitchedOnAdditionalBreakTimesAndIds()
        saveSwitchedOnAdditionalWorkTimesAndIds(workTimes)
        saveSwitchedOnAdditionalBreakTimesAndIds(breakTimes)
    }
    
    //MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CreateAdditionalTimeSegue":
            let createAdditionalTimeVC = segue.destination as! CreateAdditionalTimeVC
            createAdditionalTimeVC.delegate = self
        default: fatalError()
        }
    }
    
    //MARK: createAdditionalTimeVCDelegate methods
    func createAdditionalTimeVC(_ cerateAdditionalTimeVC: CreateAdditionalTimeVC, didCreateAdditionalTime additionalTime: AdditionalTime) {
        tableViewModelController.add(additionalTime)
        saveAdditionalTimes(additionalTimesStore)
        let additionalWorkTimesAndIds = getSwitchedOnAdditionalWorkTimesAndIds()
        let additionalBreakTImesAndIds = getSwitchedOnAdditionalBreakTimesAndIds()
        saveSwitchedOnAdditionalWorkTimesAndIds(additionalWorkTimesAndIds)
        saveSwitchedOnAdditionalBreakTimesAndIds(additionalBreakTImesAndIds)
    }
}

//MARK: TableViewDataSource, TableViewDelegate methods
extension AdditionalTimesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewModelController.numberOfAdditionalTimesSections
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModelController.numberOfAdditionalTimes(inSection: section)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UILabel()
        sectionHeader.backgroundColor = UIColor.gray
        let sectionTitle = tableViewModelController.sectionTitle(forSection: section)
        sectionHeader.text = sectionTitle
        return sectionHeader
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AdditionalTimeCell
        configureCell(cell: cell, atIndexPath: indexPath, from: tableViewModelController)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete :
            tableViewModelController.removeAdditionalTime(atIndexPath: indexPath)
        default: break
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        saveAdditionalTimes(additionalTimesStore)
        let additionalWorkTimesAndIds = getSwitchedOnAdditionalWorkTimesAndIds()
        let additionalBreakTImesAndIds = getSwitchedOnAdditionalBreakTimesAndIds()
        saveSwitchedOnAdditionalWorkTimesAndIds(additionalWorkTimesAndIds)
        saveSwitchedOnAdditionalBreakTimesAndIds(additionalBreakTImesAndIds)
    }
}

//MARK: Utility functions
extension AdditionalTimesTableViewController {
    private func configureCell(cell: AdditionalTimeCell, atIndexPath indexPath: IndexPath, from additionalTimes: AdditionalTimesTableViewModelController) {
        let additionalTime = tableViewModelController.additionalTime(forIndexPath: indexPath)
        let time = additionalTime.time
        let toggleState = additionalTime.toggleState
        cell.setTime(time)
        cell.setToggleState(toggleState)
    }
    
    private func customizeNavigationBar() {
        navigationItem.title = "Дополнительное время"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getTimeToggleState(_ sender: UISwitch) -> AdditionalTime.ToggleState {
        switch sender.isOn {
        case true: return AdditionalTime.ToggleState.on
        case false: return AdditionalTime.ToggleState.off
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

extension AdditionalTimesTableViewController {
    //MARK: loadAdditionalTimes()
    private func loadAdditionalTimes() -> AdditionalTimesStore {
        guard let data = loadAdditionalTimesDataFromUserDefaults() else { return AdditionalTimesStore() }
        guard let additionalTimesStore = unarchiveAdditionalTimesData(data) else { fatalError() }
        return additionalTimesStore
    }
    private func loadAdditionalTimesDataFromUserDefaults() -> Data? {
        let userDefaults = UserDefaults(suiteName: TaskTrackerGroupID.id)
        let additionalTimesData = userDefaults?.data(forKey: UserDefaultsKeys.additionalTimesKey)
        return additionalTimesData
    }
    private func unarchiveAdditionalTimesData(_ data: Data) -> AdditionalTimesStore? {
        let additionalTimes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AdditionalTimesStore
        return additionalTimes!
    }
}
extension AdditionalTimesTableViewController {
    //MARKL: saveAdditionalTimes
    private func saveAdditionalTimes(_ times: AdditionalTimesStore) {
        let data = try! NSKeyedArchiver.archivedData(withRootObject: times, requiringSecureCoding: false)
        let userDefaults = UserDefaults(suiteName: TaskTrackerGroupID.id)
        userDefaults!.set(data, forKey: UserDefaultsKeys.additionalTimesKey)
    }
}

extension AdditionalTimesTableViewController {
    private func getSwitchedOnAdditionalWorkTimesAndIds() -> SwitchedOnAdditionalWorkTimesAndIds {
        let timesAndIds = additionalTimesStore.additionalTimes.filter { $0.toggleState == .on && $0.type == .workTime }.map { (UUID.init().uuidString, $0.time) }
        return Dictionary(uniqueKeysWithValues: timesAndIds)
    }
    private func getSwitchedOnAdditionalBreakTimesAndIds() -> SwitchedOnAdditionalBreakTimesAndIds {
        let timesAndIds = additionalTimesStore.additionalTimes.filter { $0.toggleState == .on && $0.type == .breakTime }.map { (UUID.init().uuidString, $0.time) }
        return Dictionary(uniqueKeysWithValues: timesAndIds)
    }
}
typealias SwitchedOnAdditionalWorkTimesAndIds = [String : TimeInterval]
typealias SwitchedOnAdditionalBreakTimesAndIds = [String : TimeInterval]
