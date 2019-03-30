//
//  DeadlineVCDelegate.swift
//  TaskKiller
//
//  Created by mac on 25/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol DeadlineVCDelegate {
    func deadlineVC(_ deadlineVC: DeadlineVC, didChoseDeadline deadline: TimeInterval)
}
