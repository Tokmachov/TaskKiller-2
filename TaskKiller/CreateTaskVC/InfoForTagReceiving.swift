//
//  TagInfoReceiving.swift
//  TaskKiller
//
//  Created by mac on 16/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol InfoForTagReceiving: AnyObject {
    func receiveInfoForTag(name: String, color: UIColor)
}
