//
//  DeadlinePostponingVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 18.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct DeadlinePostponingVCFactoryImp: DeadlinePostponingVCFactory {

    let title = "Pospone deadline?"
    let messege = "Chose new deadline"
    
    func createDeadlinePostponingVC(deadlines: [TimeInterval], postponeHandler: @escaping (TimeInterval) -> (), finishHandler: @escaping  () -> ()) -> DeadlinePostponingVC {
        let alertVC = UIAlertController(title: title, message: messege, preferredStyle: UIAlertController.Style.actionSheet)
        
        for deadline in deadlines {
            let postponeAlertAction = UIAlertAction(title: String(deadline), style: .default, handler: { _ in postponeHandler(deadline) })
            alertVC.addAction(postponeAlertAction)
        }
        let finishAlertAction = UIAlertAction(title: "Finish task", style: UIAlertAction.Style.destructive, handler: { _ in finishHandler() })
        alertVC.addAction(finishAlertAction)
        return alertVC
    }
}
