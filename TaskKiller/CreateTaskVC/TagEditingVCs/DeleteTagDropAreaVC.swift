//
//  DeleteTagVC.swift
//  TaskKiller
//
//  Created by mac on 06/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DeleteTagDropAreaVC: UIViewController, UIDropInteractionDelegate {
    private var tagFactory: TagFactory!
    override func viewDidLoad() {
        super.viewDidLoad()
        tagFactory = TagFactoryImp()
    }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if session.items.first!.localObject != nil {
            return true
        } else {
            return false
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .move)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let tag: Tag = (session.items.first?.localObject as AnyObject) as? Tag else { return }
        tagFactory.deleteTagFromMemory(tag)
    }
}
