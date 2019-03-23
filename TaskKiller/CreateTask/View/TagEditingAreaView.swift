//
//  TagEditingArea.swift
//  TaskKiller
//
//  Created by mac on 03/01/2019.
//  Copyright © 2019 Oleg Tokmachov. All rights reserved.
//

import UIKit

class TagEditingAreaView: UIView {
    
    private var stackForDropAreasPositioning: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
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
    func removeDropArea(_ view: UIView) {
        stackForDropAreasPositioning.removeArrangedSubview(view)
    }
}

extension TagEditingAreaView {
    func setupView() {
        backgroundColor = TagEditingAreaSetups.backgroundColor.withAlphaComponent(TagEditingAreaSetups.alpha)
        addStackForDropAreasPositioning()
    }
    private func addStackForDropAreasPositioning() {
        self.addSubview(stackForDropAreasPositioning)
        NSLayoutConstraint.activate([
            stackForDropAreasPositioning.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackForDropAreasPositioning.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
    }
}
