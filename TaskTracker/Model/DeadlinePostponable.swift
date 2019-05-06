//
//  DeadlinePostponable.swift
//  TaskTracker

// Protocol forms interface of Task and TaskProgressModel 

import Foundation

protocol DeadlinePostponable {
    func postponeDeadlineFor(_ timeInterval: TimeInterval)
}
