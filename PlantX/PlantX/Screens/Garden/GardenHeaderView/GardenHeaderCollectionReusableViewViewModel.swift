//
//  GardenHeaderCollectionReusableViewViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 08.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class GardenHeaderCollectionReusableViewViewModel {

    // MARK: - Properties
    let event = PublishSubject<Event>()
    lazy var quickActionsViewViewModel = BehaviorRelay<QuickActionsViewViewModel>(value: createQuickActionsViewViewModel())
    private let disposeBag = DisposeBag()

    // MARK: - Private
    private func createQuickActionsViewViewModel() -> QuickActionsViewViewModel {
        let viewModel = QuickActionsViewViewModel()
        viewModel.event.bind(onNext: { [weak self] event in
            guard let self else { return }
            switch event {
            case .didPressWater: self.event.onNext(.didPressWater)
            case .didPressFertilize: self.event.onNext(.didPressFertilize)
            }
        }).disposed(by: disposeBag)
        return viewModel
    }
}

// MARK: - EventTransmitter
extension GardenHeaderCollectionReusableViewViewModel: EventTransmitter {

    enum Event {
        case didPressWater
        case didPressFertilize
    }

}
