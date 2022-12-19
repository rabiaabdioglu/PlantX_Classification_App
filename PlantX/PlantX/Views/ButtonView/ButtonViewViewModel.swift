//
//  ButtonViewViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 05.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import Foundation

struct ButtonViewViewModel {

    // MARK: - Properties
    let kind: Kind
    let title: String
    let action: () -> Void

}

// MARK: - Kind
extension ButtonViewViewModel {

    enum Kind {
        case primary
        case secondary
        case destructive
    }
}
