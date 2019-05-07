//
//  TaskProgressSaving.swift
//  TaskTracker

// Protocol forms interface of Task and TaskProgressModel 


import Foundation

protocol TaskProgressSaving {
    func saveProgressPeriod(_ period: ProgressPeriod)
}
