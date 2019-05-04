//
//  Tag.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit
import CoreData

protocol Tag {
    var id: String { get }
    var name: String { get set }
    var color: UIColor { get set }
}
