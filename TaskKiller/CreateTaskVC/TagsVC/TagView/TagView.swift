//
//  TagView.swift
//  TaskKiller
//
//  Created by mac on 13/12/2018.
//  Copyright © 2018 Oleg Tokmachov. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TagView: UIView, TagInfoSetable {
    
    @IBInspectable var cornerRadius: CGFloat = 10
    
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet weak var colorButton: ColorChangeButton!
    @IBOutlet weak var deleteButton: DeleteButton!
    
    private var tagColor: UIColor = UIColor.green {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.clear
        isOpaque = false
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        path.addClip()
        tagColor.setFill()
        path.fill()
    }
    func setTagInfo(from tag: Tag) {
        let tagName = tag.getName()
        let tagColor = tag.getColor()
        self.setTagName(tagName)
        self.setTagColor(tagColor)
    }
    
    
    //MARK: TagViewModeSetable
    func goToEditingMode() {
        prepareInterfaceForEditingMode()
    }
    func goToNotEditingMode() {
        prepareInterfaceForNotEditingMode()
    }
}

extension TagView {
    private func setTagName(_ tagName: String) {
        tagNameLabel.text = tagName
        tagTextField.text = tagName
    }
    
    private func setTagColor(_ tagColor: UIColor) {
        self.tagColor = tagColor
        colorButton.setColorDotColor(tagColor)
    }
    
    private func prepareInterfaceForEditingMode() {
        colorButton.show()
        deleteButton.show()
        tagNameLabel.hide()
        tagTextField.show()
    }
    
    private func prepareInterfaceForNotEditingMode() {
        colorButton.hide()
        deleteButton.hide()
        tagTextField.hide()
        tagNameLabel.show()
    }
}
