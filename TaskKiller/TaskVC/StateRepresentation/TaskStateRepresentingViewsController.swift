//
//  StateUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskStateRepresentingViewsController: TaskStateRepresenting {
    
    private let startButton: UIButton
    
    init(startButton: UIButton) {
        self.startButton = startButton
    }
    func makeStartedUI() {
        showStoppedButton()
    }
    func makeStoppedUI() {
        showStartButton()
    }
    
    private func showStartButton() {
        startButton.setTitle("Start", for: .normal)
    }
    
    private func showStoppedButton() {
        startButton.setTitle("Stopped", for: .normal)
    }
}
