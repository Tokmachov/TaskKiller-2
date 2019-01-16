//
//  DeleteTagFromTaskVC.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagRemovingFromTaskDropAreaVC: UIViewController, UIDropInteractionDelegate {
    
    private weak var tagFromTaskRemovingDelegate: TagFromTaskRemovingDelegate!
    
    func setTagFromTaskRemovalPerfomingDelegate(_ delegate: TagFromTaskRemovingDelegate) {
        tagFromTaskRemovingDelegate = delegate
    }
    
    //MARK: UIDropInteractionDelegate
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasLocalObject(ofType: Tag.self)
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let tag = session.provideLocalObject(ofType: Tag.self) else { return }
        tagFromTaskRemovingDelegate.performRemovingTask(of: tag)
    }
}

