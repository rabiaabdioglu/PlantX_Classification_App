//
//  PlantDetailsViewController.swift
//  Plantasia
//
//  Created by bogdan razvan on 27/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import DTPhotoViewerController
import RxSwift

class PlantDetailsViewController: BaseViewController<PlantDetailsViewModel>, AlertPresenter, UIScrollViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var actionBarBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var actionBarTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var actionBarContainerView: UIView!
    @IBOutlet private weak var quickActionsView: QuickActionsView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageTopGradientView: UIView!
    @IBOutlet private weak var imageShadowContainerView: UIView!
    @IBOutlet private weak var imageRoundedCornersContainerView: UIView!
    @IBOutlet private weak var nameLabelView: LabelView!
    @IBOutlet private weak var descriptionStackView: UIStackView!
    @IBOutlet private weak var descriptionLabelView: LabelView!
    @IBOutlet private weak var wateringLabelView: LabelView!
    @IBOutlet private weak var fertilizingLabelView: LabelView!
    @IBOutlet private weak var ownedSinceStackView: UIStackView!
    @IBOutlet private weak var ownedSinceLabelView: LabelView!
    @IBOutlet private weak var wateringPercentageLabel: UILabel!
    @IBOutlet private weak var fertilizingPercentageLabel: UILabel!
    @IBOutlet private weak var photoGalleryButtonView: ButtonView!
    @IBOutlet private weak var wateringPercentageStackView: UIStackView!
    @IBOutlet private weak var fertilizingPercentageStackView: UIStackView!

    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let bottomPadding: CGFloat = 104
    private var gradientLayer: CAGradientLayer?

    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, animations: {
            self.showActionBarView()
        })
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = imageTopGradientView.bounds
    }

    // MARK: - Internal
    override func setupUI() {
        super.setupUI()
        setupScrollView()
        setupActionBarRoundedContainerView()
        setupActionBarShadowContainerView()
        setupImageTopGradientView()
        setupImageRounderCornersContainerView()
        setupImageShadowContainerView()
        setupImageView()
        hideActionBarView()
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.plant.map { $0.getImage() }.bind(to: imageView.rx.image).disposed(by: disposeBag)
        viewModel.nameLabelViewViewModel.bind(to: nameLabelView.viewModel).disposed(by: disposeBag)
        viewModel.descriptionLabelViewViewModel.bind(to: descriptionLabelView.viewModel).disposed(by: disposeBag)
        viewModel.wateringLabelViewViewModel.bind(to: wateringLabelView.viewModel).disposed(by: disposeBag)
        viewModel.fertilizingLabelViewViewModel.bind(to: fertilizingLabelView.viewModel).disposed(by: disposeBag)
        viewModel.ownedSinceLabelViewViewModel.bind(to: ownedSinceLabelView.viewModel).disposed(by: disposeBag)
        viewModel.photoGalleryButtonViewViewModel.bind(to: photoGalleryButtonView.viewModel).disposed(by: disposeBag)
        viewModel.plant.map { ($0.descr ?? "").isEmpty }.bind(to: descriptionStackView.rx.isHidden).disposed(by: disposeBag)
        viewModel.plant.map { $0.getFertilizingRemainingDays() == nil }.bind(to: fertilizingPercentageStackView.rx.isHidden).disposed(by: disposeBag)
        viewModel.quickActionsViewViewModel.bind(to: quickActionsView.viewModel).disposed(by: disposeBag)
        viewModel.plant.map { $0.ownedSinceDate?.toShortMonthDateString() == nil }.bind(to: ownedSinceStackView.rx.isHidden).disposed(by: disposeBag)
        viewModel.plant.map { "\($0.getWateringPercentage())%" }.bind(to: wateringPercentageLabel.rx.text).disposed(by: disposeBag)
        viewModel.plant.map {
            if let fertilizingPercentage = $0.getFertilizingPercentage() {
                return "\(fertilizingPercentage)%"
            } else {
                return nil
            }
        }.bind(to: fertilizingPercentageLabel.rx.text).disposed(by: disposeBag)

        viewModel.event.subscribe(onNext: { [weak self] value in
            guard let self else { return }
            switch value {
            case .didFertilizePlant:
                self.fertilizingLabelView.animateScale()
                self.fertilizingPercentageStackView.animateScale()
            case .didWaterPlant:
                self.wateringLabelView.animateScale()
                self.wateringPercentageStackView.animateScale()
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

    // MARK: - Private
    private func setupImageView() {
        imageView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            let viewController = DTPhotoViewerController(referencedView: self.imageView, image: self.imageView.image)
            self.present(viewController, animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        setupEditButton()
    }

    private func setupActionBarRoundedContainerView() {
        actionBarContainerView.layer.cornerRadius = 10
        actionBarContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private func setupActionBarShadowContainerView() {
        actionBarContainerView.layer.shadowRadius = 5
        actionBarContainerView.layer.shadowColor = UIColor.black.cgColor
        actionBarContainerView.layer.shadowOpacity = 0.4
        actionBarContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    }

    private func setupImageTopGradientView() {
        let gradientLayer = CAGradientLayer()
        self.gradientLayer = gradientLayer
        gradientLayer.frame = imageTopGradientView.bounds
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.clear.cgColor]
        imageTopGradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupImageRounderCornersContainerView() {
        imageRoundedCornersContainerView.layer.cornerRadius = 10
        imageRoundedCornersContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }

    private func setupImageShadowContainerView() {
        imageShadowContainerView.layer.shadowRadius = 5
        imageShadowContainerView.layer.shadowColor = UIColor.black.cgColor
        imageShadowContainerView.layer.shadowOpacity = 0.4
        imageShadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    }

    private func setupEditButton() {
        let editButton = UIBarButtonItem(title: "edit".localized, style: .plain, target: self, action: #selector(editButtonPressed))
        editButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .normal)
        navigationItem.rightBarButtonItem = editButton
    }

    @objc
    private func editButtonPressed() {
        viewModel.event.onNext(.didPressEditPlant)
    }

    private func setupScrollView() {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 0)
        scrollView.rx.didScroll.observe(on: MainScheduler.asyncInstance).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            if self.scrollView.contentOffset.y < 0 {
                self.scrollView.contentOffset.y = 0
            }
        }).disposed(by: disposeBag)
    }

    private func hideActionBarView() {
        actionBarBottomConstraint.constant = -bottomPadding
        actionBarTopConstraint.constant = 0
        view.layoutIfNeeded()
    }

    private func showActionBarView() {
        actionBarBottomConstraint.constant = 0
        actionBarTopConstraint.constant = bottomPadding
        view.layoutIfNeeded()
    }

}
