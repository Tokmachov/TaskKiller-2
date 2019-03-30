//
//  TagFactory.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol TagFactory {
    func createTag(name: String, color: UIColor) -> Tag
    func createTag(tagModel: TagModel) -> Tag
    func deleteTagFromMemory(_ tag: Tag)
}

