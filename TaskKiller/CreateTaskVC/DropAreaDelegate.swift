//
//  DropAreaDelegate.swift
//  TaskKiller
//
//  Created by mac on 05/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol DropAreaDelegate: AnyObject {
    func prepareDropArea()
    func dropAreaIsNoLongerNeeded()
}
