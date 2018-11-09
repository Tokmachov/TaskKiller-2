//
//  TagsVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagsVC: UIViewController, TagsReporting {
    
    private var tagsSamples: [TagInfo] = [TagInfo(progectName: "Work"), TagInfo(progectName: "Programming")]
    private var tagsReceiver: TagInfosReceiving!
    
    func setTagsReceiver(_ receiver: TagInfosReceiving) {
        self.tagsReceiver = receiver
    }
    override func viewDidLoad() {
        self.viewDidLoad()
        tagsReceiver.receiveTagsInfos(tagsSamples)
    }
}
