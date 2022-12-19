//
//  QuickActionsViewViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 08.12.2022.
//  Copyright © 2022 archlime solutions. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct QuickActionsViewViewModel {

    // MARK: - Properties
    let isFertilizeHidden = BehaviorRelay<Bool>(value: false)
    let event = PublishSubject<Event>()

}

// MARK: - EventTransmitter
extension QuickActionsViewViewModel: EventTransmitter {

    enum Event {
        case didPressWater
        case didPressFertilize
    }

}
