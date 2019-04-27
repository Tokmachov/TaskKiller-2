//
//  StateUIComponents.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 13.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TaskStateRepresentingViewsController: TaskStateRepresenting {
    
    private let startStopButton: UIButton
    private var playButtonImage: UIImage? {
        return UIImage(named: "playButton")
    }
    private var stopButtonImage: UIImage? {
        return UIImage(named: "stopButton")
    }
    
    init(startButton: UIButton) {
        self.startStopButton = startButton
    }
    
    func makeStartedUI() {
        showStopButton()
    }
    func makeStoppedUI() {
        showStartButton()
    }
    
    private func showStartButton() {
        guard let playButtonImage = playButtonImage else {
            setStopStartButtonName(to: "Stop")
            return
        }
        setStartStopButtonImage(playButtonImage)
    }
    
    private func showStopButton() {
        guard let stopButtonImage = stopButtonImage else {
            setStopStartButtonName(to: "Start")
            return
        }
        setStartStopButtonImage(stopButtonImage)
    }
}

extension TaskStateRepresentingViewsController {
    private func setStopStartButtonName(to name: String) {
        startStopButton.setTitle(name, for: .normal)
    }
    private func setStartStopButtonImage(_ image: UIImage) {
        startStopButton.setBackgroundImage(image, for: .normal)
    }
}
