//
//  CartViewController.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartViewController: UIViewController {
	// MARK: - IBOutlets
	@IBOutlet private weak var emptyCartButton: UIButton!
	@IBOutlet private weak var listingTableView: UITableView!
	@IBOutlet private weak var totalAmountLabel: UILabel!
	@IBOutlet private weak var proceedToPayButton: UIButton!

	// MARK: - Dependencies
	private var viewModel: CartViewModel?

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension CartViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		bindRx()
	}
}

// MARK: - Setup
extension CartViewController {
	func setup(shopViewModel: ShopViewModel) {
		viewModel = CartViewModel(shopViewModel: shopViewModel)
	}

	private func configureTableView() {
		listingTableView.register(UINib(nibName: "ListingTableViewCell", bundle: nil), forCellReuseIdentifier: "cartCell")
		//		listingTableView.register(ListingCell)
		listingTableView.allowsSelection = false
	}

	private func bindRx() {
		guard let viewModel = viewModel else {
			assertionFailure()
			return
		}

		viewModel.items
			.bind(to: listingTableView.rx.items(cellIdentifier: "cartCell", cellType: ListingTableViewCell.self)) { [weak self] (_, item, cell) in
				if let viewModel = self?.viewModel {
					cell.setUp(shopViewModel: viewModel.shopViewModel, item: item)
				}
			}
			.disposed(by: disposeBag)

		viewModel.totalAmountString
			.bind(to: totalAmountLabel.rx.text)
			.disposed(by: disposeBag)

		emptyCartButton.rx.tap
			.subscribe(onNext: { viewModel.performAction(.emptyCart) })
			.disposed(by: disposeBag)

		viewModel.shouldReturnToShop
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] shouldReturn in
				if shouldReturn { self?.navigationController?.popViewController(animated: true) }
			})
			.disposed(by: disposeBag)
	}
}
