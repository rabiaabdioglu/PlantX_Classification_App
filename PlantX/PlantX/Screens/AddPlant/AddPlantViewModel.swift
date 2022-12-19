//
//  AddPlantViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 25/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift

class AddPlantViewModel: BaseViewModel {

    // MARK: - Properties

    // Name
    lazy var nameTextFieldViewViewModel = BehaviorRelay<TextFieldViewViewModel>(value: createNameTextFieldViewViewModel())
    private var name: String? {
        get { nameTextFieldViewViewModel.value.text.value }
        set { nameTextFieldViewViewModel.value.text.accept(newValue) }
    }

    // Description
    lazy var descriptionTextViewViewViewModel = BehaviorRelay<TextViewViewViewModel>(value: createDescriptionTextViewViewViewModel())
    private var description: String? {
        get { descriptionTextViewViewViewModel.value.text.value }
        set { descriptionTextViewViewViewModel.value.text.accept(newValue) }
    }

    // Watering
    lazy var wateringTextFieldViewViewModel = BehaviorRelay<TextFieldViewViewModel>(value: createWateringTextFieldViewViewModel())
    private let wateringDaysPickerOptions: [Int] = Array(1...30)
    private var wateringFrequency: Int = 2

    // Fertilizing
    lazy var fertilizingTextFieldViewViewModel = BehaviorRelay<TextFieldViewViewModel>(value: createFertilizingTextFieldViewViewModel())
    private let fertilizingDaysPickerOptions: [Int] = Array(0...30) + [45, 60]
    private var fertilizingFrequency: Int = 14

    // Owned Since
    lazy var ownedSinceDatePickerViewViewModel = BehaviorRelay<DatePickerViewViewModel>(value: createOwnedSinceDatePickerViewViewModel())
    private var ownedSince: Date {
        get { ownedSinceDatePickerViewViewModel.value.date.value }
        set { ownedSinceDatePickerViewViewModel.value.date.accept(newValue) }
    }

    // Buttons
    lazy var deletePlantButtonViewViewModel = BehaviorRelay<ButtonViewViewModel>(value: createDeletePlantButtonViewViewModel())
    lazy var doneButtonViewViewModel = BehaviorRelay<ButtonViewViewModel>(value: createDoneButtonViewViewModel())

    let event = PublishSubject<Event>()
    let plantImage = BehaviorRelay<UIImage?>(value: nil)
    private let plantsService: PlantsServiceProtocol
    private let disposeBag = DisposeBag()
    private let editedPlant: Plant?

    // MARK: - Lifecycle
    init(editedPlant: Plant? = nil, plantsService: PlantsServiceProtocol) {
        self.editedPlant = editedPlant
        self.plantsService = plantsService
        super.init()
        name = editedPlant?.name
        description = editedPlant?.descr
        if let wateringFrequency = editedPlant?.wateringFrequencyDays.value {
            self.wateringFrequency = wateringFrequency
        }
        if let fertilizingFrequency = editedPlant?.fertilizingFrequencyDays.value {
            self.fertilizingFrequency = fertilizingFrequency
        }
        ownedSince = editedPlant?.ownedSinceDate ?? Date()
        plantImage.accept(editedPlant?.getImage())
    }

    // MARK: - Internal
    func deletePlant() {
        guard let plant = editedPlant else { return }
        do {
            try plantsService.delete(plant)
            event.onNext(.didRemovePlant)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    func isEditingExistingPlant() -> Bool {
        return editedPlant != nil
    }

    // MARK: - Private
    private func create(_ plant: Plant) {
        do {
            try plantsService.create(plant)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    private func updatePlant() {
        guard let plant = editedPlant else { return }
        do {
            try plantsService.update(plant,
                                     name: name,
                                     descr: description,
                                     wateringFrequencyDays: wateringFrequency,
                                     fertilizingFrequencyDays: fertilizingFrequency,
                                     image: plantImage.value,
                                     ownedSinceDate: ownedSince)
        } catch {
            AnalyticsService.track(error: error)
        }
    }

    private func isInputDataComplete() -> Bool {
        return !(name ?? "").isEmpty && plantImage.value != nil
    }

    private func createNameTextFieldViewViewModel() -> TextFieldViewViewModel {
        TextFieldViewViewModel(title: "name".localized)
    }

    private func createDescriptionTextViewViewViewModel() -> TextViewViewViewModel {
        TextViewViewViewModel(title: "notes".localized)
    }

    private func createOwnedSinceDatePickerViewViewModel() -> DatePickerViewViewModel {
        DatePickerViewViewModel(
            title: "owned-since".localized,
            datePickerMode: .date,
            maximumDate: Date()
        )
    }

    private func createWateringTextFieldViewViewModel() -> TextFieldViewViewModel {
        let viewModel = TextFieldViewViewModel(
            title: "watering".localized,
            text: String(format: "every-days-frequency".localized, wateringFrequency),
            pickerData: .init(
                values: wateringDaysPickerOptions.map { String(format: "days-frequency".localized, $0) },
                selectedRow: wateringDaysPickerOptions.firstIndex(of: wateringFrequency) ?? 0
            )
        )
        viewModel.pickerData?.selectedRow.bind(onNext: { [weak self] value in
            guard let self else { return }
            self.wateringFrequency = self.wateringDaysPickerOptions[value]
            viewModel.text.accept(String(format: "every-days-frequency".localized, self.wateringFrequency) )
        }).disposed(by: disposeBag)
        return viewModel
    }

    private func createFertilizingTextFieldViewViewModel() -> TextFieldViewViewModel {
        let viewModel = TextFieldViewViewModel(
            title: "fertilizing".localized,
            text: String(format: "every-days-frequency".localized, fertilizingFrequency),
            pickerData: .init(
                values: fertilizingDaysPickerOptions.map { String(format: "days-frequency".localized, $0) },
                selectedRow: fertilizingDaysPickerOptions.firstIndex(of: fertilizingFrequency) ?? 0
            )
        )
        viewModel.pickerData?.selectedRow.bind(onNext: { [weak self] value in
            guard let self else { return }
            self.fertilizingFrequency = self.fertilizingDaysPickerOptions[value]
            viewModel.text.accept(String(format: "every-days-frequency".localized, self.fertilizingFrequency) )
        }).disposed(by: disposeBag)
        return viewModel
    }

    private func createDeletePlantButtonViewViewModel() -> ButtonViewViewModel {
        ButtonViewViewModel(kind: .destructive, title: "remove".localized) { [weak self] in
            self?.event.onNext(.didPressRemovePlant)
        }
    }

    private func createDoneButtonViewViewModel() -> ButtonViewViewModel {
        ButtonViewViewModel(kind: .primary, title: "save".localized) { [weak self] in
            self?.saveValidatedPlant()
        }
    }

    private func saveValidatedPlant() {
        if isInputDataComplete() {
            if isEditingExistingPlant() {
                updatePlant()
                event.onNext(.didUpdatePlant)
            } else {
                let plant = Plant(name: name,
                                  descr: description,
                                  wateringFrequencyDays: wateringFrequency,
                                  fertilizingFrequencyDays: fertilizingFrequency,
                                  image: plantImage.value,
                                  lastWateringDate: Date(),
                                  lastFertilizingDate: Date(),
                                  photos: [],
                                  ownedSinceDate: ownedSince)
                create(plant)
                event.onNext(.didCreatePlant)
            }
            PushNotificationService.shared.requestPushNotificationAuthorization()
        } else {
            error.onNext(GeneralError(title: "missing-information".localized, message: "please-take-image-and-name".localized))
        }
    }

}

// MARK: - EventTransmitter
extension AddPlantViewModel: EventTransmitter {

    enum Event {
        case didCreatePlant
        case didUpdatePlant
        case didPressRemovePlant
        case didRemovePlant
        case didPressClose
    }

}

// MARK: - PickerSelection
extension AddPlantViewModel {
    enum PickerSelection {
        case watering
        case fertilizing
    }

}
