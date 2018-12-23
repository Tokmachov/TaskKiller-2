//
//  TagFactory.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol TagFactory {
    static func createTag(from name: String, and color: UIColor) -> Tag
    static func createTag(from tagModel: TagModel) -> Tag
}

