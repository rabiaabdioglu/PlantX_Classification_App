//
//  PlantDetailsCollectionViewCell.swift
//  Plantasia
//
//  Created by bogdan razvan on 26/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import UIKit

class PlantDetailsCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var shadowContainerView: UIView!
    @IBOutlet private weak var roundedContainerView: UIView!
    @IBOutlet private weak var plantImageView: UIImageView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var wateringLabel: UILabel!
    @IBOutlet private weak var fertilizingStackView: UIStackView!
    @IBOutlet private weak var fertilizingLabel: UILabel!

    // MARK: - Properties
    var viewModel: PlantDetailsCollectionViewCellViewModel! {
        didSet {
            configurePlantDetails()
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Private
    private func configurePlantDetails() {
        let plant = viewModel.plant
        nameLabel.text = plant.name
        wateringLabel.text = "\(plant.getWateringPercentage())%"
        wateringLabel.textColor = plant.requiresWatering() ? UIColor.orangeFE865D : UIColor.white
        if let fertilizingPercentage = plant.getFertilizingPercentage() {
            fertilizingStackView.isHidden = false
            fertilizingLabel.text = "\(fertilizingPercentage)%"
            fertilizingLabel.textColor = plant.requiresFertilizing() ? UIColor.orangeFE865D : UIColor.white
        } else {
            fertilizingStackView.isHidden = true
        }
        plantImageView.image = plant.getImage()
        setupShadowContainerView(requiresAttention: plant.requiresAttention())
    }

    private func setupUI() {
        setupGradientView()
        roundedContainerView.layer.cornerRadius = 10
    }

    private func setupGradientView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupShadowContainerView(requiresAttention: Bool) {
        shadowContainerView.layer.shadowRadius = requiresAttention ? 15 : 5
        shadowContainerView.layer.shadowColor = requiresAttention ? UIColor.orangeFE865D.cgColor : UIColor.black.cgColor
        shadowContainerView.layer.shadowOpacity = requiresAttention ? 1 : 0.4
        shadowContainerView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    }
    
}
