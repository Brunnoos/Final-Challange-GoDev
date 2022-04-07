//
//  ViewCodable.swift
//  FinalChallange-Github
//
//  Created by Idwall Go Dev 006 on 27/03/22.
//

import UIKit

public protocol ViewCodable {

    func buildHierarchy()

    func setupConstraints()

    func applyAdditionalChanges()
}

public extension ViewCodable {

    func setupView() {
        buildHierarchy()
        setupConstraints()
        applyAdditionalChanges()
    }

    func buildHierarchy() {}

    func setupConstraints() {}

    func applyAdditionalChanges() {}
}
