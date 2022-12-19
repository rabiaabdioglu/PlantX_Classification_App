//
//  GardenViewController.swift
//  Plantasia
//
//  Created by bogdan razvan on 25/04/2020.
//  Copyright © 2020 archlime solutions. All rights reserved.
//

import MessageUI
import RxGesture
import RxSwift
import UIKit

class GardenViewController: BaseViewController<GardenViewModel>, AlertPresenter {

    // MARK: - IBOutlets
    @IBOutlet private weak var emptyGardenContainerView: UIView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var filledGardenContainerView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle
    override init(viewModel: GardenViewModel) {
        super.init(viewModel: viewModel)
        hidesBottomBarWhenPushed = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black232323
        setupContainerViewsVisibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPlusButtonAnimation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        plusButton.layer.removeAllAnimations()
    }

    // MARK: - Internal
    override func setupUI() {
        super.setupUI()
        navigationItem.title = viewModel.title
        plusButton.layer.cornerRadius = plusButton.bounds.height / 2
        setupCollectionView()
    }

    override func setupBindings() {
        super.setupBindings()
        bindPlusButton()
        bindPlants()
        bindEvent()
    }
    // MARK: - Private
    private func bindPlusButton() {
        plusButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self else { return }
            self.didPressAddPlant()
        }).disposed(by: disposeBag)
    }

    private func bindPlants() {
        viewModel.plants.subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            self.setupContainerViewsVisibility()
            DispatchQueue.main.async {
                self.collectionView.performBatchUpdates({
                    self.collectionView.reloadSections(IndexSet(integer: 0))
                })
        }
        }).disposed(by: disposeBag)
    }

    private func bindEvent() {
        viewModel.event.subscribe(onNext: { [weak self] event in
            guard let self else { return }
            switch event {
            case .didPressWater:
                self.showTwoActionsAlert(title: "water-plants".localized,
                                         firstButtonText: "water-dehydrated".localized,
                                         firstButtonHandler: { self.viewModel.waterDehydratedPlants() },
                                         secondButtonText: "water-all".localized,
                                         secondButtonHandler: { self.viewModel.waterAllPlants() })
            case .didWaterPlants:
                self.showAlert(title: "plants-been-watered".localized)
            case .didPressFertilize:
                self.showTwoActionsAlert(title: "fertilize-plants".localized,
                                         firstButtonText: "fertilize-unfertilized".localized,
                                         firstButtonHandler: { self.viewModel.fertilizeUnfertilizedPlants() },
                                         secondButtonText: "fertilize-all".localized,
                                         secondButtonHandler: { self.viewModel.fertilizeAllPlants() })
            case .didFertilizePlants:
                self.showAlert(title: "plants-been-fertilized".localized)
            default:
                break
            }
        }).disposed(by: disposeBag)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        collectionView.registerCellNib(name: PlantDetailsCollectionViewCell.className)
        collectionView.registerHeaderNib(name: GardenHeaderCollectionReusableView.className)

        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
    }

    private func setupPlusButtonAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(value: 0.9)
        animation.duration = 1
        animation.repeatCount = 100
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        plusButton.layer.add(animation, forKey: nil)
    }
    
    private func setupAddPlantBarButtonItem() {
        if viewModel.getPlantsCount() > 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.plusThinIcon?.resized(to: .square(25)),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(didPressAddPlant))
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func setupSortPlantsBarButtonItem() {
        if viewModel.getPlantsCount() > 0 {
            let menuItems = [
                UIAction(title: "hydration".localized, image: nil) { _ in self.viewModel.sortingCriteria.onNext(.hydration) },
                UIAction(title: "fertilization".localized, image: nil) { _ in self.viewModel.sortingCriteria.onNext(.fertilization) },
                UIAction(title: "owned-since".localized, image: nil) { _ in self.viewModel.sortingCriteria.onNext(.ownedSince) }
            ]

            let menu = UIMenu(title: "sort-by".localized, image: nil, identifier: nil, options: [], children: menuItems)
            let button = UIBarButtonItem(title: nil, image: UIImage.sortIcon?.resized(to: .square(25)), primaryAction: nil, menu: menu)
            navigationItem.leftBarButtonItem = button
        } else {
            navigationItem.leftBarButtonItem = nil
        }
    }

    private func setupContainerViewsVisibility() {
        if viewModel.getPlantsCount() == 0 {
            filledGardenContainerView.isHidden = true
            emptyGardenContainerView.isHidden = false
        } else {
            filledGardenContainerView.isHidden = false
            emptyGardenContainerView.isHidden = true
        }
        setupAddPlantBarButtonItem()
        setupSortPlantsBarButtonItem()
    }
    
    @objc
    private func didPressAddPlant() {
        viewModel.event.onNext(.didPressAddPlant)
    }

}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate
extension GardenViewController: UICollectionViewDelegateFlowLayout,
                                UICollectionViewDragDelegate,
                                UICollectionViewDropDelegate,
                                UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 156, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = viewModel.getPlant(atIndex: indexPath.row)
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath,
              destinationIndexPath.row >= 0, coordinator.items.count == 1,
              let item = coordinator.items.first,
              let sourceIndexPath = item.sourceIndexPath,
              let draggedPlant = item.dragItem.localObject as? Plant
        else { return }

        collectionView.performBatchUpdates({
            self.viewModel.movePlant(draggedPlant, fromPosition: sourceIndexPath.row, toPosition: destinationIndexPath.row)
            collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
        })
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let destinationIndexPath = destinationIndexPath,
                session.localDragSession != nil,
                destinationIndexPath.row >= 0 else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let plant = viewModel.getPlant(atIndex: indexPath.row)
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let waterAction = UIAction(title: "water".localized, image: .water) { _ in
                self.viewModel.water(plant: plant)
            }
            let shareAction = UIAction(title: "share".localized, image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.viewModel.event.onNext(.didSelectShare(plant: plant))
            }

            if plant.canBeFertilized() {
                let fertilizeAction = UIAction(title: "fertilize".localized, image: .fertilizer) { _ in
                    self.viewModel.fertilize(plant: plant)
                }
                return UIMenu(title: "", children: [waterAction, fertilizeAction, shareAction])
            } else {
                return UIMenu(title: "", children: [waterAction, shareAction])
            }
        })
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: PlantDetailsCollectionViewCell.className, for: indexPath) as? PlantDetailsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = PlantDetailsCollectionViewCellViewModel(plant: viewModel.getPlant(atIndex: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.event.onNext(.didSelect(plant: viewModel.getPlant(atIndex: indexPath.row)))
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getPlantsCount()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 90)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: GardenHeaderCollectionReusableView.className,
            for: indexPath
           ) as? GardenHeaderCollectionReusableView {
            viewModel.gardenHeaderCollectionReusableViewViewModel.bind(to: headerView.viewModel).disposed(by: disposeBag)
            return headerView
        }
        return UICollectionReusableView()
    }

}

// MARK: - MFMessageComposeViewControllerDelegate
extension GardenViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
