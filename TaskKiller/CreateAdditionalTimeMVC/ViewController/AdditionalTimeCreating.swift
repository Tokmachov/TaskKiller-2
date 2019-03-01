//
//  AdditionalTimesSetable.swift
//  TaskKiller
//
//  Created by mac on 26/02/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation
protocol AdditionalTimeCreating {
    var delegate: AdditionalTimeSavingDelegate! { get set }
}
