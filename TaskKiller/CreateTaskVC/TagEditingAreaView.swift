//
//  TagEditingArea.swift
//  TaskKiller
//
//  Created by mac on 03/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagEditingAreaView: UIView {
    let customColorForBackGround = UIColor.white
    let customAlpha: CGFloat = 0.5
    
    private var stackForDropAreasPositioning: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addDropArea(_ view: UIView) {
        stackForDropAreasPositioning.addArrangedSubview(view)
    }
}

extension TagEditingAreaView {
    func setupView() {
        backgroundColor = TagEditingAreaSetups.backgroundColor.withAlphaComponent(TagEditingAreaSetups.alpha)
        addStackForDropAreasPositioning()
    }
    private func addStackForDropAreasPositioning() {
        stackForDropAreasPositioning = UIStackView()
        self.addSubview(stackForDropAreasPositioning)
        configureStack(stackForDropAreasPositioning)
        stackForDropAreasPositioning.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackForDropAreasPositioning.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackForDropAreasPositioning.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
    private func configureStack(_ stack: UIStackView) {
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
    }
}
