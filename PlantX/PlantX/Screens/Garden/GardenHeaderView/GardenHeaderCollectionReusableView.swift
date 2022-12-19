//
//  GardenHeaderCollectionReusableView.swift
//  Plantasia
//
//  Created by bogdan razvan on 27.11.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class GardenHeaderCollectionReusableView: UICollectionReusableView {

    // MARK: - IBOutlets
    @IBOutlet private weak var quickActionsContainerView: UIView!
    @IBOutlet private weak var quickActionsView: QuickActionsView!
    
    // MARK: - Properties
    let viewModel = BehaviorRelay<GardenHeaderCollectionReusableViewViewModel?>(value: nil)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        bindViewModel()
    }

    // MARK: - Private
    private func setupUI() {
        setupQuickActionsContainerView()
    }

    private func setupQuickActionsContainerView() {
        quickActionsContainerView.layer.shadowColor = UIColor.black.cgColor
        quickActionsContainerView.layer.shadowOpacity = 0.1
        quickActionsContainerView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
    }

    private func bindViewModel() {
        viewModel.bind(onNext: { [weak self] viewModel in
            guard let self, let viewModel else { return }
            self.setup(with: viewModel)
        }).disposed(by: disposeBag)
    }

    private func setup(with viewModel: GardenHeaderCollectionReusableViewViewModel) {
        viewModel.quickActionsViewViewModel.bind(to: quickActionsView.viewModel).disposed(by: disposeBag)
    }

}
