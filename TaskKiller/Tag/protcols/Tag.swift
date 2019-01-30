//
//  Tag.swift
//  TaskKiller
//
//  Created by mac on 19/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol Tag  {
    func getName() -> String
    func getColor() -> UIColor
    func getTagModel() -> TagModel
    func setName(_ name: String)
    func setColor(_ color: UIColor)
}
