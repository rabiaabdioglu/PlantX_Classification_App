//
//  QuickActionsView.swift
//  Plantasia
//
//  Created by bogdan razvan on 08.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class QuickActionsView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var waterView: UIView!
    @IBOutlet private weak var fertilizeView: UIView!

    // MARK: - Properties
    let viewModel = BehaviorRelay<QuickActionsViewViewModel?>(value: nil)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        bindViewModel()
    }

    // MARK: - Private
    private func setupUI() {
        Bundle.main.loadNibNamed(Self.className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds

        setupWaterView()
        setupFertilizeView()
    }

    private func setupWaterView() {
        waterView.layer.cornerRadius = 10
        waterView.layer.borderWidth = 2
        waterView.layer.borderColor = UIColor.blue69A8AD.cgColor
        waterView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.waterView.flash()
            self.viewModel.value?.event.onNext(.didPressWater)
        }).disposed(by: disposeBag)
    }

    private func setupFertilizeView() {
        fertilizeView.layer.cornerRadius = 10
        fertilizeView.layer.borderWidth = 2
        fertilizeView.layer.borderColor = UIColor.orangeFE865D.cgColor
        fertilizeView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.fertilizeView.flash()
            self.viewModel.value?.event.onNext(.didPressFertilize)
        }).disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.bind(onNext: { [weak self] viewModel in
            guard let self, let viewModel else { return }
            self.setup(with: viewModel)
        }).disposed(by: disposeBag)
    }

    private func setup(with viewModel: QuickActionsViewViewModel) {
        viewModel.isFertilizeHidden.bind(to: fertilizeView.rx.isHidden).disposed(by: disposeBag)
    }

}
