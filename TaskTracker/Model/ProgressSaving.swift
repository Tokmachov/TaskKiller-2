//
//  TaskProgressSaving.swift
//  TaskTracker

// Protocol forms interface of Task and TaskProgressModel 


import Foundation

protocol ProgressSaving {
    func saveProgressPeriod(_ period: ProgressPeriod)
}
