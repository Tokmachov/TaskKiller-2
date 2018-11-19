//
//  StateRepresentor.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

struct StateRepresentor: StateRepresenting {
    func makeStarted(_ uIComponents: StateRepresentingUIComponents) {
        uIComponents.showStartButton()
    }
    
    func makeStopped(_ uIComponents: StateRepresentingUIComponents) {
        uIComponents.showStoppedButton()
    }
}
