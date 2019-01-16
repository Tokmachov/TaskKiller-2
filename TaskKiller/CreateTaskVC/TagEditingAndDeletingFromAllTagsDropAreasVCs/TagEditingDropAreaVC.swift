//
//  EditTagDropAreaVC.swift
//  TaskKiller
//
//  Created by mac on 08/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagEditingDropAreaVC: UIViewController, UIDropInteractionDelegate {
    
    var editTagPerformingDelegate: EditTagPerformingDelegate!
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        guard (session.items.first?.localObject as AnyObject) as? Tag != nil else { return false }
        return true
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let tag = (session.items.first!.localObject as AnyObject) as? Tag else { return }
        editTagPerformingDelegate.performEditing(of: tag)
    }
}

