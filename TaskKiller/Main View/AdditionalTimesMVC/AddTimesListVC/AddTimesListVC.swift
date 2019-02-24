//
//  AddTimesListVC.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class AddTimesListVC: UITableViewController {
    
    private lazy var userDefaults = UserDefaults(suiteName: AppGroupsID.taskKillerGroup)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add times"
        navigationController?.navigationBar.prefersLargeTitles = true
        let data = userDefaults?.data(forKey: "testAddTimes")
        let addTimes = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data!) as! AdditionalTimes
        for value in addTimes.additionalWorkTimes {
            print("Value \(value.time)")
        }
    }
}
