//
//  DeadlinePostponingVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 18.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct DeadlinePostponingVCFactory: IDeadlinePostponingVCFactory {

    let title = "Pospone deadline?"
    let messege = "Chose new deadline"
    private let possibleDeadlines: [TimeInterval]
    private let postponeAction: (TimeInterval)->()
    private let finishAction: ()->()
    init(possibleDeadlines: [TimeInterval], postponeAction: @escaping (TimeInterval) -> (), finishAction: @escaping  () -> ()) {
        self.possibleDeadlines = possibleDeadlines
        self.postponeAction = postponeAction
        self.finishAction = finishAction
    }
    
    func createDeadlinePostponingVC() -> DeadlinePostponingVC {
        let alertVC = UIAlertController(title: title, message: messege, preferredStyle: UIAlertController.Style.actionSheet)
        for deadline in possibleDeadlines {
            let postponeAlertAction = createPostponeAlertAction(deadline: deadline, postponeAction: postponeAction)
            alertVC.addAction(postponeAlertAction)
        }
        let finishAlertAction = createFinishAction(finishAction: finishAction)
        alertVC.addAction(finishAlertAction)
        return alertVC
    }
    private func createPostponeAlertAction(deadline: TimeInterval, postponeAction: @escaping (TimeInterval) -> ()) -> UIAlertAction {
            let title = "Postpone for \(deadline)"
            let handler = createActionHanddler(deadline: deadline, postponeAction: postponeAction)
            let action = UIAlertAction(title: title, style: .default, handler: handler)
            return action
    }
    private func createActionHanddler(deadline: TimeInterval, postponeAction: @escaping (TimeInterval) -> ()) -> (UIAlertAction) -> () {
        return { _ in postponeAction(deadline) }
    }
    private func createFinishAction(finishAction: @escaping ()->() ) -> UIAlertAction {
        let finishAlertAction: (UIAlertAction) -> () = { _ in finishAction() }
        let alertAction = UIAlertAction(title: "Finish task", style: UIAlertAction.Style.destructive, handler: finishAlertAction)
        return alertAction
    }
    
}
