//
//  TextFieldViewViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 04.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

struct TextFieldViewViewModel {

    // MARK: - Properties
    let title: String
    let text: BehaviorRelay<String?>
    let placeholder: String?
    let pickerData: PickerData?

    // MARK: - Lifecycle
    init(
        title: String,
        text: String? = nil,
        placeholder: String? = nil,
        pickerData: PickerData? = nil
    ) {
        self.title = title
        self.text = .init(value: text)
        self.placeholder = placeholder
        self.pickerData = pickerData
    }

}

// MARK: - PickerData
extension TextFieldViewViewModel {

    /// Used for displaying a picker when editing the text field.
    struct PickerData {
        let values: [String]
        let selectedRow: BehaviorRelay<Int>

        init(
            values: [String],
            selectedRow: Int
        ) {
            self.values = values
            self.selectedRow = .init(value: selectedRow)
        }
    }

}
