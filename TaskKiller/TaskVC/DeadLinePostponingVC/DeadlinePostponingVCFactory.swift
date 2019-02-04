//
//  PostponableDeadineVCCreating.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 18.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
typealias DeadlinePostponingVC = UIAlertController

protocol DeadlinePostponingVCFactory {
    func createDeadlinePostponingVC(deadlines: [TimeInterval], postponeHandler: @escaping (TimeInterval) -> (), finishHandler: @escaping  () -> ()) -> DeadlinePostponingVC
}
