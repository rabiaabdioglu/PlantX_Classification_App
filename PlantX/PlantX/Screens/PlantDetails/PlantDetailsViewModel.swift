//
//  PlantDetailsViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 27/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift

class PlantDetailsViewModel: BaseViewModel {

    // MARK: - Properties
    let event = PublishSubject<Event>()
    let plant: BehaviorRelay<Plant>
    lazy var nameLabelViewViewModel = BehaviorRelay<LabelViewViewModel>(value: createNameLabelViewViewModel())
    lazy var descriptionLabelViewViewModel = BehaviorRelay<LabelViewViewModel>(value: createDescriptionLabelViewViewModel())
    lazy var wateringLabelViewViewModel = BehaviorRelay<LabelViewViewModel>(value: createWateringLabelViewViewModel())
    lazy var fertilizingLabelViewViewModel = BehaviorRelay<LabelViewViewModel>(value: createFertilizingLabelViewViewModel())
    lazy var ownedSinceLabelViewViewModel = BehaviorRelay<LabelViewViewModel>(value: createOwnedSinceLabelViewViewModel())
    lazy var photoGalleryButtonViewViewModel = BehaviorRelay<ButtonViewViewModel>(value: createPhotoGalleryButtonViewViewModel())
    lazy var quickActionsViewViewModel = BehaviorRelay<QuickActionsViewViewModel>(value: createQuickActionsViewViewModel())
    private let disposeBag = DisposeBag()
    private let plantsService: PlantsServiceProtocol

    // MARK: - Lifecycle
    init(plant: Plant, plantsService: PlantsServiceProtocol) {
        self.plant = BehaviorRelay(value: plant)
        self.plantsService = plantsService
        super.init()
        observePlant()
    }

    // MARK: - Private
    private func waterPlant() {
        do {
            try plantsService.water(plant.value)
            event.onNext(.didWaterPlant)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    private func fertilizePlant() {
        do {
            try plantsService.fertilize(plant.value)
            event.onNext(.didFertilizePlant)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    private func observePlant() {
        do {
            try plantsService.observePlant(withId: plant.value.id) { [weak self] plant in
                self?.plant.accept(plant)
            }
        } catch {
            AnalyticsService.track(error: error)
            self.error.onNext(GeneralError(title: "cant-load-plant".localized, message: "please-restart".localized))
        }
    }

    private func createNameLabelViewViewModel() -> LabelViewViewModel {
        let viewModel = LabelViewViewModel()
        plant.map(\.name).bind(to: viewModel.text).disposed(by: disposeBag)
        return viewModel
    }

    private func createDescriptionLabelViewViewModel() -> LabelViewViewModel {
        let viewModel = LabelViewViewModel()
        plant.map(\.descr).bind(to: viewModel.text).disposed(by: disposeBag)
        return viewModel
    }

    private func createWateringLabelViewViewModel() -> LabelViewViewModel {
        let viewModel = LabelViewViewModel()
        plant.map { plant in
            let remainingWateringDays = plant.getWateringRemainingDays()
            if remainingWateringDays == 0 {
                return "watering-today".localized
            } else if remainingWateringDays == 1 {
                return "watering-tomorrow".localized
            } else {
                return String(format: "watering-in-days".localized, remainingWateringDays)
            }
        }.bind(to: viewModel.text).disposed(by: disposeBag)
        return viewModel
    }

    private func createFertilizingLabelViewViewModel() -> LabelViewViewModel {
        let viewModel = LabelViewViewModel()
        plant.map { plant in
            if let remainingFertilizingDays = plant.getFertilizingRemainingDays() {
                if remainingFertilizingDays == 0 {
                    return "fertilizing-today".localized
                } else if remainingFertilizingDays == 1 {
                    return "fertilizing-tomorrow".localized
                } else {
                    return String(format: "fertilizing-in-days".localized, remainingFertilizingDays)
                }
            } else {
                return "fertilizing-never".localized
            }
        }.bind(to: viewModel.text).disposed(by: disposeBag)
        return viewModel
    }

    private func createOwnedSinceLabelViewViewModel() -> LabelViewViewModel {
        let viewModel = LabelViewViewModel()
        plant.map { plant in
            guard let ownedSinceValue = plant.ownedSinceDate?.toShortMonthDateString() else { return nil }
            return String(format: "owned-since-value".localized, ownedSinceValue)
        }.bind(to: viewModel.text).disposed(by: disposeBag)
        return viewModel
    }

    private func createPhotoGalleryButtonViewViewModel() -> ButtonViewViewModel {
        ButtonViewViewModel(kind: .primary, title: "photo-album".localized) { [weak self] in
            self?.event.onNext(.didPressPhotoGallery)
        }
    }

    private func createQuickActionsViewViewModel() -> QuickActionsViewViewModel {
        let viewModel = QuickActionsViewViewModel()
        viewModel.event.bind(onNext: { [weak self] event in
            guard let self else { return }
            switch event {
            case .didPressWater: self.waterPlant()
            case .didPressFertilize: self.fertilizePlant()
            }
        }).disposed(by: disposeBag)
        plant.map { $0.getFertilizingRemainingDays() == nil }.bind(to: viewModel.isFertilizeHidden).disposed(by: disposeBag)
        return viewModel
    }

}

// MARK: - EventTransmitter
extension PlantDetailsViewModel: EventTransmitter {

    enum Event {
        case didFertilizePlant
        case didPressEditPlant
        case didPressPhotoGallery
        case didWaterPlant
    }
}
