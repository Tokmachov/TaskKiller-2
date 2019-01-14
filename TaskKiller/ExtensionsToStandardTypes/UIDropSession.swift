//
//  UIDropSession.swift
//  TaskKiller
//
//  Created by mac on 14/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

extension UIDropSession {
    func hasLocalObject<T>(ofType type: T.Type) -> Bool {
        guard ((self.items.first?.localObject as AnyObject) as? T) != nil else { return false }
        return true
    }
    func provideLocalObject<T>(ofType type: T.Type) -> T? {
        guard self.hasLocalObject(ofType: T.self) else { return nil }
        let object = (self.items.first?.localObject as AnyObject) as! T
        return object
    }
}
