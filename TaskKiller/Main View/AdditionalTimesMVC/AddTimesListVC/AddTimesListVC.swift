//
//  AddTimesListVC.swift
//  TaskKiller
//
//  Created by mac on 20/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class AddTimesListVC: UITableViewController {
    
    private lazy var userDefaults = UserDefaults(suiteName: TaskKillerGroupID.id)
    private lazy var additionalTimes: AdditionalTimes = {
        guard let additionalTimesData = userDefaults?.data(forKey: UserDefaultsKeys.additionalTimesId) else { return AdditionalTimes() }
        guard let addtionalTimes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(additionalTimesData) as? AdditionalTimes else { fatalError() }
        return addtionalTimes!
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add times"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
