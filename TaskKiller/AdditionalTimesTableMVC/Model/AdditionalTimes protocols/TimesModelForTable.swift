//
//  AdditionalTimesModelForTable.swift
//  TaskKiller
//
//  Created by mac on 02/03/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import Foundation

typealias TimesModelForTable = RepresentableInSectionedTable & AdditionalTimesEditable &  SwitchedOnAdditionalTimesReadable & AdditionalTimes & AdditionalTimeRemovable & NSCoding
