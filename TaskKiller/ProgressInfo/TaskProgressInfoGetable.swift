//
//  ProgressInfoGetable.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 18.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskProgressInfoGetable {
    func getProgressInfo() -> TaskProgressInfo
}
