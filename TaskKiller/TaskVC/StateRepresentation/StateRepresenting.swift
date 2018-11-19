//
//  StateRepresenting.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol StateRepresenting {
    func makeStarted(_ uIComponents: StateRepresentingUIComponents)
    func makeStopped(_ uIComponents: StateRepresentingUIComponents)
}
