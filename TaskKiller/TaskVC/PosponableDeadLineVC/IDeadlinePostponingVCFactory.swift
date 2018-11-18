//
//  PostponableDeadineVCCreating.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 18.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
typealias DeadlinePostponingVC = UIAlertController

protocol IDeadlinePostponingVCFactory {
    init(possibleDeadlines: [TimeInterval], postponeAction: @escaping (TimeInterval)->(), finishAction: @escaping ()->())
    func createDeadlinePostponingVC() -> DeadlinePostponingVC
}
