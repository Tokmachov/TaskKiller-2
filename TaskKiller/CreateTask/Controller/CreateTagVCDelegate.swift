//
//  CreateTagVCDelegate.swift
//  TaskKiller
//
//  Created by mac on 29/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol CreateTagVCDelegate {
    func createTagVCDelegate(_ createTagVCDelegate: CreateTagVC, didChoseName name: String, AndColor color: UIColor)
}
