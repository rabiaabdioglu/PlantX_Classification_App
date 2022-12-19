//
//  TextViewViewViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 04.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import RxCocoa
import UIKit

struct TextViewViewViewModel {

    // MARK: - Properties
    let title: String
    let text = BehaviorRelay<String?>(value: nil)

    // MARK: - Lifecycle
    init(title: String) {
        self.title = title
    }

}
