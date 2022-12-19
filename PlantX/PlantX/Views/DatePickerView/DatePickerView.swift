//
//  DatePickerView.swift
//  Plantasia
//
//  Created by bogdan razvan on 04.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class DatePickerView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var datePicker: UIDatePicker!

    // MARK: - Properties
    let viewModel = BehaviorRelay<DatePickerViewViewModel?>(value: nil)
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

        datePicker.tintColor = .green90D599
    }

    private func bindViewModel() {
        viewModel.bind(onNext: { [weak self] viewModel in
            guard let self, let viewModel else { return }
            self.setup(with: viewModel)
        }).disposed(by: disposeBag)
    }

    private func setup(with viewModel: DatePickerViewViewModel) {
        titleLabel.text = viewModel.title
        datePicker.datePickerMode = viewModel.datePickerMode
        (datePicker.rx.value <-> viewModel.date).disposed(by: disposeBag)
        datePicker.maximumDate = viewModel.maximumDate
    }
}
