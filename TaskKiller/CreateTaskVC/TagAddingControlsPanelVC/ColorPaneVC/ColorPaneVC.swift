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
    private var chosenColorReceiver: ColorChosenForTagReceiving!
    func setColorChosenForTagReceiver(_ receiver: ColorChosenForTagReceiving) {
        self.chosenColorReceiver = receiver
    }
    
    @IBAction func colorSelectionButtonPressed(_ sender: ColorSelectionButton) {
        chosenColorReceiver.colorForTagWasChosen(sender.getColor())
        
    }

}
