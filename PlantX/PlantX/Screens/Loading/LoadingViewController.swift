//
//  LoadingViewController.swift
//  Plantasia
//
//  Created by bogdan razvan on 24/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import RxSwift

class LoadingViewController: BaseViewController<LoadingViewModel> {

    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.viewModel.event.onNext(.didFinishLoading)
        })
    }

}
