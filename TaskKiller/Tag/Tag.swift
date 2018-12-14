//
//  Tag.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct Tag: Equatable {
    private var name: String
    private var color: UIColor
    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
    }
    func getName() -> String {
        return name
    }
    func getColor() -> UIColor {
        return color
    }
}
