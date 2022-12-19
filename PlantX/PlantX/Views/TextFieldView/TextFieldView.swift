//
//  TextFieldView.swift
//  Plantasia
//
//  Created by bogdan razvan on 04.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TextFieldView: UIView {

    // MARK: - IBOutlets
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var textFieldContainerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textField: UITextField!

    // MARK: - Properties
    let viewModel = BehaviorRelay<TextFieldViewViewModel?>(value: nil)
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

        setupTextFieldContainerView()
        textField.showDoneButton()
    }

    private func setupTextFieldContainerView() {
        textFieldContainerView.layer.cornerRadius = 8
    }

    private func bindViewModel() {
        viewModel.bind(onNext: { [weak self] viewModel in
            guard let self, let viewModel else { return }
            self.setup(with: viewModel)
        }).disposed(by: disposeBag)
    }

    private func setup(with viewModel: TextFieldViewViewModel) {
        titleLabel.text = viewModel.title
        (textField.rx.text <-> viewModel.text).disposed(by: disposeBag)
        textField.placeholder = viewModel.placeholder

        if let pickerData = viewModel.pickerData {
            setupPicker(with: pickerData)
        }
    }

    private func setupPicker(with data: TextFieldViewViewModel.PickerData) {
        let pickerView = UIPickerView()
        textField.inputView = pickerView
        textField.tintColor = .clear

        Observable.of(data.values).bind(to: pickerView.rx.itemTitles) { _, value in
            return String(value)
        }.disposed(by: disposeBag)
        pickerView.rx.itemSelected.map(\.row).bind(to: data.selectedRow).disposed(by: disposeBag)
        textField.rx.controlEvent(.editingDidBegin).bind(onNext: { _ in
            pickerView.selectRow(data.selectedRow.value, inComponent: 0, animated: true)
        }).disposed(by: disposeBag)
    }

}
