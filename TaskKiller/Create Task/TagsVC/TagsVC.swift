//
//  TagsVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagsVC: TagsReporting {
    
    private var tagsReceiver: TagsReceiving!
    
    func setTagsReceiver(_ receiver: TagsReceiving) {
        self.tagsReceiver = receiver
    }
}
