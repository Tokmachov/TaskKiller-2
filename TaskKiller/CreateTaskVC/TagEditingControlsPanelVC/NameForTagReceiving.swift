//
//  TagNameReceiver.swift
//  TaskKiller
//
//  Created by mac on 18/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol NameForTagReceiving: AnyObject {
    func receiveNameForTag(_ name: String)
}
