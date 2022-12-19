//
//  SeparatorView.swift
//  Plantasia
//
//  Created by bogdan razvan on 05.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import UIKit

class SeparatorView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - Private
    private func setupUI() {
        Bundle.main.loadNibNamed(Self.className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
    }

}
