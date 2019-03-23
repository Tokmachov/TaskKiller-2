//
//  ColorPane.swift
//  TaskKiller
//
//  Created by mac on 16/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class ColorPaneVC: UIViewController, ColorChosenForTagReporting {
    
    //MARK: ChosenColorReporting
    private var chosenColorReceiver: ColorPaneControllerDelegate!
    func setColorChosenForTagReceiver(_ receiver: ColorPaneControllerDelegate) {
        self.chosenColorReceiver = receiver
    }
    
    @IBAction func colorSelectionButtonPressed(_ sender: ColorSelectionButton) {
        chosenColorReceiver.colorPaneController(self, didChoseColor: sender.getColor())
    }

}
