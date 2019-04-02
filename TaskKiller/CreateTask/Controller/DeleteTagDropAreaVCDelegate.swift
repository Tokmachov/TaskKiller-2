//
//  DeleteTagDelegate.swift
//  TaskKiller
//
//  Created by mac on 15/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

protocol DeleteTagDropAreaVCDelegate {
    func deleteTagDropAreaVC(_ deleteTagDropAraeaVC: DeleteTagDropAreaVC, needToBeDeleted tag: Tag)
}
