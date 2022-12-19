//
//  DatePickerViewViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 04.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa

struct DatePickerViewViewModel {

    // MARK: - Properties
    let title: String
    let date: BehaviorRelay<Date>
    let datePickerMode: UIDatePicker.Mode
    let maximumDate: Date?

    // MARK: - Lifecycle
    init(
        title: String,
        date: Date = .init(),
        datePickerMode: UIDatePicker.Mode,
        maximumDate: Date? = nil
    ) {
        self.title = title
        self.date = .init(value: date)
        self.datePickerMode = datePickerMode
        self.maximumDate = maximumDate
    }

}
