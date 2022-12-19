//
//  TabBarViewController.swift
//  Plantasia
//
//  Created by bogdan razvan on 02/05/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import RxSwift
import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - Properties
    private let customTabBarView: CustomTabBarView = .fromNib()
    private let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
        customTabBarView.selectedIndex.accept(0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let newTabBarHeight = tabBar.frame.size.height + 30

        var newFrame = tabBar.frame
        newFrame.size.height = newTabBarHeight
        newFrame.origin.y = view.frame.size.height - newTabBarHeight

        tabBar.frame = newFrame
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        customTabBarView.selectedIndex.accept(selectedIndex)
    }

    // MARK: - Private
    private func setupUI() {
        setupTabBar()
        setupCustomTabBarView()
    }

    private func setupTabBar() {
        let appearance = tabBar.standardAppearance
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .black232323
        tabBar.backgroundColor = .clear
    }

    private func setupCustomTabBarView() {
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(customTabBarView)

        NSLayoutConstraint.activate([
            customTabBarView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            customTabBarView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            customTabBarView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            customTabBarView.bottomAnchor.constraint(equalTo: tabBar.bottomAnchor)
        ])
    }

}
