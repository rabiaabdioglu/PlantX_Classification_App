//
//  ButtonView.swift
//  Plantasia
//
//  Created by bogdan razvan on 05.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ButtonView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var button: UIButton!
    
    // MARK: - Properties
    let viewModel = BehaviorRelay<ButtonViewViewModel?>(value: nil)
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

        button.layer.cornerRadius = 10
    }

    private func bindViewModel() {
        viewModel.bind(onNext: { [weak self] viewModel in
            guard let self, let viewModel = viewModel else { return }
            self.setup(with: viewModel)
        }).disposed(by: disposeBag)
    }

    private func setup(with viewModel: ButtonViewViewModel) {
        button.setTitle(viewModel.title, for: .normal)
        switch viewModel.kind {
        case .primary:
            button.backgroundColor = .green90D599
            button.setTitleColor(UIColor.white, for: .normal)
        case .secondary:
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.green90D599.cgColor
            button.setTitleColor(UIColor.green90D599, for: .normal)
        case .destructive:
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.orangeFE865D.cgColor
            button.setTitleColor(UIColor.orangeFE865D, for: .normal)
        }

        button.rx.tap.bind { viewModel.action() }.disposed(by: disposeBag)
    }

}
