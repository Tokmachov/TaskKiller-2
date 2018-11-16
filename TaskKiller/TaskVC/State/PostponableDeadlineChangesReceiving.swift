//
//  PostponableTimeReceivable.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 15.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol PostponableDeadlineChangesReceiving: AnyObject {
    func postponableDeadLineDidchanged(_ deadline: TimeInterval)
}
