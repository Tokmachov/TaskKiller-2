//
//  DeleteTagVC.swift
//  TaskKiller
//
//  Created by mac on 06/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DeleteTagDropAreaVC: UIViewController, UIDropInteractionDelegate {
    
    //MARK: factory
    private var tagFactory: TagFactory!
    
    //MARK: delegate
    var delegate: DeleteTagDropAreaVCDelegate!
    
    //MARK: Actions
    @IBOutlet weak var dropAreaView: DropAreaBackgroundView! {
        didSet {
            let dropInteraction = UIDropInteraction(delegate: self)
            dropAreaView.addInteraction(dropInteraction)
        }
    }
    
    //MARK: ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tagFactory = TagFactoryImp()
    }
    
    //MARK: UIDropInteractionDelegate
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if (session.items.first?.localObject as AnyObject) as? Tag != nil {
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
        delegate.deleteTagDropAreaVC(self, needsToBeDeleted: tag)
    }
}
