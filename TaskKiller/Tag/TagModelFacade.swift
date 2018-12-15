//
//  Tag.swift
//  TaskKiller
//
//  Created by Oleg Tokmachov on 08.11.2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

struct TagModelFacade: Equatable {
    
    private var tagModel: TagModel
    init(tagModel: TagModel) {
        self.tagModel = tagModel
    }
    
    func getName() -> String {
        guard let name = tagModel.name else { fatalError() }
        return name
    }
    func getColor() -> UIColor {
        guard let color = tagModel.color else { fatalError() }
        return color
    }
}
