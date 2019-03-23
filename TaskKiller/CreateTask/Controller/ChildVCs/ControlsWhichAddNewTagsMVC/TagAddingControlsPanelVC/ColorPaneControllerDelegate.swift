//
//  ChosenColorReceiving.swift
//  TaskKiller
//
//  Created by mac on 17/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

protocol ColorPaneControllerDelegate {
    func colorPaneController(_ colorPaneController: ColorPaneVC, didChoseColor color: UIColor)
}
