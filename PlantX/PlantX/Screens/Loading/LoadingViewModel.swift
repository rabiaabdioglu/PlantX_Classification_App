//
//  LoadingViewModel.swift
//  Plantasia
//
//  Created by bogdan razvan on 29.09.2021.
//  Copyright © 2021 archlime solutions. All rights reserved.
//

import RxSwift

class LoadingViewModel: BaseViewModel {

    // MARK: - Properties
    let event = PublishSubject<Event>()
    
}

// MARK: - EventTransmitter
extension LoadingViewModel: EventTransmitter {
    enum Event {
        case didFinishLoading
    }
}
