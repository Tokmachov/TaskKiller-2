//
//  deadLineVC.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class DeadLineVC: DeadLineReporting {
    
    private var deadLineReceiver: DeadLineReceiving!
    
    func setDeadLineRerceiver(_ receiver: DeadLineReceiving) {
        self.deadLineReceiver = receiver
    }
}
