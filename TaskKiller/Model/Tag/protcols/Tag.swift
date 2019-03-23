//
//  Tag.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol Tag  {
    var name: String { get set }
    var color: UIColor { get set }
    var tagModel: TagModel { get }
}
