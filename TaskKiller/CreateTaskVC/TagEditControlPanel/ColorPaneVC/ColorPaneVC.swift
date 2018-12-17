//
//  ColorPane.swift
//  TaskKiller
//
//  Created by mac on 16/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class ColorPaneVC: UIViewController, ChosenColorReporting {
    
    //MARK: ChosenColorReporting
    private var chosenColorReceiver: ChosenColorReceiving!
    func setChosenColorReceiver(_ receiver: ChosenColorReceiving) {
        self.chosenColorReceiver = receiver
    }
    
    @IBAction func colorSelectionButtonPressed(_ sender: ColorSelectionButton) {
        chosenColorReceiver.colorWasChosen(sender.getColor())
        
    }

}
