//
//  GardenViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 26/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift

class GardenViewModel: BaseViewModel {

    // MARK: - Properties
    let title = "garden".localized
    let event = PublishSubject<Event>()
    let plants = BehaviorRelay<[Plant]>(value: [])
    let sortingCriteria = PublishSubject<SortingCriteria>()
    lazy var gardenHeaderCollectionReusableViewViewModel = BehaviorRelay<GardenHeaderCollectionReusableViewViewModel>(
        value: createGardenHeaderCollectionReusableViewViewModel()
    )
    private let disposeBag = DisposeBag()
    private var plantsService: PlantsServiceProtocol
    
    // MARK: - Lifecycle
    init(plantsService: PlantsServiceProtocol) {
        self.plantsService = plantsService
        super.init()
        observePlants()
        bindSortingCriteria()
    }

    // MARK: - Internal
    func movePlant(_ plant: Plant, fromPosition: Int, toPosition: Int) {
        do {
            try plantsService.move(plant, fromPosition: fromPosition, toPosition: toPosition)
            movePlantInMemory(plant, fromPosition: fromPosition, toPosition: toPosition)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    func waterAllPlants() {
        do {
            try plantsService.waterAllPlants()
            event.onNext(.didWaterPlants)
        } catch {
            AnalyticsService.track(error: error)
        }
    }
    
    func waterDehydratedPlants() {
        do {
            try plantsService.waterDehydratedPlants()
            event.onNext(.didWaterPlants)
        } catch {
            AnalyticsService.track(error: error)
        }
    }
    
    func fertilizeAllPlants() {
        do {
            try plantsService.fertilizeAllPlants()
            event.onNext(.didFertilizePlants)
        } catch {
            AnalyticsService.track(error: error)
        }
    }
    
    func fertilizeUnfertilizedPlants() {
        do {
            try plantsService.fertilizeUnfertilizedPlants()
            event.onNext(.didFertilizePlants)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    func getPlant(atIndex index: Int) -> Plant {
        return plants.value[index]
    }

    func getPlantsCount() -> Int {
        return plants.value.count
    }

    func water(plant: Plant) {
        do {
            try plantsService.water(plant)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    func fertilize(plant: Plant) {
        do {
            try plantsService.fertilize(plant)
        } catch {
            AnalyticsService.track(error: error)
        }
    }
    
    // MARK: - Private
    private func observePlants() {
        do {
            try plantsService.observeSortedPlants { [weak self] plants in
                guard let self else { return }
                self.plants.accept(plants)
            }
        } catch {
            AnalyticsService.track(error: error)
            self.error.onNext(GeneralError(title: "cant-load-plants".localized, message: "please-restart".localized))
        }
    }

    private func sortByHydration() {
        do {
            try plantsService.sortByHydration()
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    private func sortByFertilization() {
        do {
            try plantsService.sortByFertilization()
        } catch {
            AnalyticsService.track(error: error)
        }
    }
    
    private func sortByOwnedSince() {
        do {
            try plantsService.sortByOwnedSince()
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    private func bindSortingCriteria() {
        sortingCriteria.subscribe(onNext: {[weak self] value in
            guard let self else { return }
            switch value {
            case .hydration:
                self.sortByHydration()
            case .fertilization:
                self.sortByFertilization()
            case .ownedSince:
                self.sortByOwnedSince()
            }
        }).disposed(by: disposeBag)
    }

    /// Moves the given plant to a position to another inside the in-memory array.
    /// This is needed in order to achieve instant UI changes on drag-and-drop inside the collection view.
    /// - Parameters:
    ///   - plant: the plant to be moved.
    ///   - fromPosition: initial position.
    ///   - toPosition: destination position.
    private func movePlantInMemory(_ plant: Plant, fromPosition: Int, toPosition: Int) {
        var tempPlants = plants.value
        tempPlants.remove(at: fromPosition)
        tempPlants.insert(plant, at: toPosition)
        plants.accept(tempPlants)
    }

    private func createGardenHeaderCollectionReusableViewViewModel() -> GardenHeaderCollectionReusableViewViewModel {
        let viewModel = GardenHeaderCollectionReusableViewViewModel()
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
extension GardenViewModel: EventTransmitter {

    enum Event: Equatable {
        case didPressWater
        case didWaterPlants
        case didPressFertilize
        case didFertilizePlants
        case didPressAddPlant
        case didSelect(plant: Plant)
        case didSelectShare(plant: Plant)
    }

}

// MARK: - SortingCriteria
extension GardenViewModel {

    enum SortingCriteria {
        case hydration
        case fertilization
        case ownedSince
    }

}
