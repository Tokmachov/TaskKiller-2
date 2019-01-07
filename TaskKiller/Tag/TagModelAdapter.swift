//
//  Tag.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TagModelAdapter: Tag, Equatable {
    
    private var adaptee: TagModel
    init(tagModel: TagModel) {
        self.adaptee = tagModel
    }
    
    func getName() -> String {
        guard let name = adaptee.name else { fatalError() }
        return name
    }
    func getColor() -> UIColor {
        guard let color = adaptee.color else { fatalError() }
        return color as! UIColor
    }
    func getTagModel() -> TagModel {
        return adaptee
    }
}
