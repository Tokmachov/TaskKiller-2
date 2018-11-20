//
//  StateRepresenting.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol TaskStateRepresenting {
    func makeStarted(_ views: TaskStateRepresentable)
    func makeStopped(_ views: TaskStateRepresentable)
}
