//
//  TaskDescriptionVCDelegate.swift
//  TaskKiller
//
//  Created by mac on 26/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskDescriptionVCDelegate {
    func taskDescriptionVC(_ taskDescriptionVC: TaskDescriptionVC, didEnterDescription taskDescription: String)
}
