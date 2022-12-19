//
//  CustomTabBarView.swift
//  Plantasia
//
//  Created by bogdan razvan on 03.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CustomTabBarView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private weak var gardenImageView: UIImageView!
    @IBOutlet private weak var settingsImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!

    // MARK: - Properties
    let selectedIndex = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContainerView()
        setupBindings()
    }

    // MARK: - Private
    private func setupContainerView() {
        containerView.layer.cornerRadius = containerView.frame.height / 2
        containerView.layer.shadowRadius = 5
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    }

    private func setupBindings() {
        selectedIndex.subscribe(onNext: { [weak self] index in
            guard let self else { return }
            UIView.animate(withDuration: 0.2) {
                self.gardenImageView.tintColor = (index == 0) ? .label : .tertiaryLabel
                self.settingsImageView.tintColor = (index == 1) ? .label : .tertiaryLabel
            }
        }).disposed(by: disposeBag)
    }

}
