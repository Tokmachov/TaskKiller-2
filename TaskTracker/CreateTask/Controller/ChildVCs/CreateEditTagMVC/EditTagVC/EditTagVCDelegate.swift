//
//  EditTagVCDelegate.swift
//  TaskKiller
//
//  Created by mac on 02/04/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol EditTagVCDelegate {
    func editTagVC(_ editTagVC: EditTagVC, didEditTag tag: Tag)
}
