//
//  NameView.swift
//  TaskKiller
//
//  Created by mac on 28/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import UIKit

class NameView: UILabel {
    
    func setName(_ name: String) {
        self.setText(name)
        self.sizeToFit()
    }
    
    func setFontSize(_ fontSize: CGFloat) {
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.sizeToFit()
    }
}
