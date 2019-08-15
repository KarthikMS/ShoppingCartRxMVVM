//
//  ListingTableViewCell.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ListingTableViewCell: UITableViewCell {
	// MARK: - Dependencies
	var viewModel: ListingTableViewCellViewModel?

	// MARK: - IBOutlets
	// MARK: - Shopping Item
	@IBOutlet private weak var labelLabel: UILabel!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var priceLabel: UILabel!
	
	// MARK: - Cart
	@IBOutlet private weak var addOneToCartButton: UIButton!
	@IBOutlet private weak var removeOneFromCartButton: UIButton!
	@IBOutlet private weak var quantityInCartLabel: UILabel!

	// MARK: - Util
	private var disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension ListingTableViewCell {
	override func prepareForReuse() {
		disposeBag = DisposeBag()
	}
}

// MARK: - Setup
extension ListingTableViewCell {
	func setUp(shopViewModel: ShopViewModel, item: ShoppingItem) {
		self.viewModel = ListingTableViewCellViewModel(shopViewModel: shopViewModel, item: item)

		// Updating View
		labelLabel.text = "\(item.label)"
		nameLabel.text = item.name
		priceLabel.text = item.priceString

		bindRx()
	}

	private func bindRx() {
		guard let viewModel = viewModel else {
			assertionFailure()
			return
		}

		viewModel.quantityOfItemsInCartString
			.bind(to: quantityInCartLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.addButtonEnabled
			.bind(to: addOneToCartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		viewModel.removeButtonEnabled
			.bind(to: removeOneFromCartButton.rx.isEnabled)
			.disposed(by: disposeBag)

		addOneToCartButton.rx.tap
			.subscribe(onNext: { viewModel.performAction(.addItemToCart) })
			.disposed(by: disposeBag)

		removeOneFromCartButton.rx.tap
			.subscribe(onNext: { viewModel.performAction(.removeItemFromCart) })
			.disposed(by: disposeBag)
	}
}
