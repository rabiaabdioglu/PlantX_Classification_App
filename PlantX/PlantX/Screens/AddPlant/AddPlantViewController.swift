//
//  AddPlantViewController.swift
//  Plantasia
//
//  Created by bogdan razvan on 25/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AddPlantViewController: BaseViewController<AddPlantViewModel>, AlertPresenter, UIScrollViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var imageTopGradientView: UIView!
    @IBOutlet private weak var imageShadowContainerView: UIView!
    @IBOutlet private weak var imageRoundedCornersContainerView: UIView!
    @IBOutlet private weak var nameTextFieldView: TextFieldView!
    @IBOutlet private weak var descriptionTextViewView: TextViewView!
    @IBOutlet private weak var wateringTextFieldView: TextFieldView!
    @IBOutlet private weak var fertilizingTextFieldView: TextFieldView!
    @IBOutlet private weak var deletePlantButtonView: ButtonView!
    @IBOutlet private weak var ownedSinceDatePickerView: DatePickerView!
    @IBOutlet private weak var doneButtonView: ButtonView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let mediaPicker = MediaPicker()
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = imageTopGradientView.bounds
    }

    // MARK: - Internal
    override func keyboardChanged(height: CGFloat) {
        scrollView.contentInset.bottom = height
    }

    override func setupUI() {
        super.setupUI()
        setupScrollView()
        setupImageView()
        setupImageTopGradientView()
        setupImageRounderCornersContainerView()
        setupImageShadowContainerView()
        setupCancelBarButtonItem()
        deletePlantButtonView.isHidden = !viewModel.isEditingExistingPlant()
    }

    override func setupBindings() {
        super.setupBindings()
        viewModel.nameTextFieldViewViewModel.bind(to: nameTextFieldView.viewModel).disposed(by: disposeBag)
        viewModel.descriptionTextViewViewViewModel.bind(to: descriptionTextViewView.viewModel).disposed(by: disposeBag)
        viewModel.wateringTextFieldViewViewModel.bind(to: wateringTextFieldView.viewModel).disposed(by: disposeBag)
        viewModel.fertilizingTextFieldViewViewModel.bind(to: fertilizingTextFieldView.viewModel).disposed(by: disposeBag)
        viewModel.ownedSinceDatePickerViewViewModel.bind(to: ownedSinceDatePickerView.viewModel).disposed(by: disposeBag)
        viewModel.deletePlantButtonViewViewModel.bind(to: deletePlantButtonView.viewModel).disposed(by: disposeBag)
        viewModel.doneButtonViewViewModel.bind(to: doneButtonView.viewModel).disposed(by: disposeBag)
        bindPlantImage()
        bindEvent()
    }

    // MARK: - Private
    private func bindPlantImage() {
        viewModel.plantImage.subscribe(onNext: { [weak self] value in
            guard let self else { return }
            if let value = value {
                self.imageView.image = value
                self.imageView.contentMode = .scaleAspectFill
            } else {
                self.imageView.image = #imageLiteral(resourceName: "camera")
                self.imageView.contentMode = .center
            }
        }).disposed(by: disposeBag)
    }

    private func bindEvent() {
        viewModel.event.bind(onNext: { [weak self] value in
            guard let self else { return }
            if value == .didPressRemovePlant {
                self.showAlert(title: "remove-plant-title".localized,
                               message: "remove-plant-description".localized,
                               buttonText: "remove".localized,
                               buttonHandler: { self.viewModel.deletePlant() },
                               buttonStyle: .destructive,
                               showCancelButton: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupScrollView() {
        scrollView.rx.didScroll.observe(on: MainScheduler.asyncInstance).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            if self.scrollView.contentOffset.y < 0 {
                self.scrollView.contentOffset.y = 0
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupImageView() {
        imageView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.view.endEditing(true)
            self.mediaPicker.pickImage(self, view: self.imageView, { image in
                self.viewModel.plantImage.accept(image)
            })
        })
        .disposed(by: disposeBag)
    }
    
    private func setupCancelBarButtonItem() {
        let cancelButton = UIBarButtonItem(image: .close, style: .plain, target: self, action: #selector(cancelButtonPressed))
        cancelButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)], for: .normal)
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    @objc
    private func cancelButtonPressed(_ sender: Any) {
        viewModel.event.onNext(.didPressClose)
    }
    
    private func setupImageTopGradientView() {
        gradientLayer = CAGradientLayer()
        guard let gradientLayer = gradientLayer else { return }
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
    
}
