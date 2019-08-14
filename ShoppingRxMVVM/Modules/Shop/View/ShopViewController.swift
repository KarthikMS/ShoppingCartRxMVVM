//
//  ShopViewController.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReusableKit
import Toast_Swift

class ShopViewController: UIViewController {
	// MARK: - IBOutlets
	@IBOutlet private weak var listingTableView: UITableView!
	@IBOutlet private weak var cartButton: UIBarButtonItem!
//	show totalAmount along with item count

	// MARK: - Properties
	private let viewModel = ShopViewModel(dataSource: ShopDataSourceImpl())

	// MARK: - Constants
	private let ListingCell = ReusableCell<ListingTableViewCell>()

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension ShopViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Shop"
		configureTableView()
		bindRx()

		// Show this properly
		view.makeToast(
			"Full",
			duration: 1.5,
			point: CGPoint(x: view.frame.size.width - 50, y: 125),
			title: nil,
			image: nil,
			style: .init(),
			completion: nil
		)
	}
}

// MARK: - Setup
private extension ShopViewController {
	func configureTableView() {
		listingTableView.register(UINib(nibName: "ListingTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
//		listingTableView.register(ListingCell)
		listingTableView.allowsSelection = false
	}

	func bindRx() {
		viewModel.itemsInCart.asObservable()
			.flatMap { Observable.just("\($0.count)") }
			.bind(to: cartButton.rx.title)
			.disposed(by: disposeBag)

		viewModel.allItems.asObservable()
			.bind(to: listingTableView.rx.items(cellIdentifier: "cell", cellType: ListingTableViewCell.self)) { [weak self] (_, item, cell) in
				if let viewModel = self?.viewModel {
					cell.setUp(shopViewModel: viewModel, item: item)
				}
			}
			.disposed(by: disposeBag)

//		viewModel.allItems.asObservable().bind(to: listingTableView.rx.items(cellIdentifier: ListingCell.identifier, cellType: ListingCell.class)) {
//			[weak self] (_, item: ShoppingItem, cell: ListingTableViewCell) in
//			if let viewModel = self?.viewModel {
//				cell.setUp(viewModel: viewModel, item: item)
//			}
//			}
//			.disposed(by: disposeBag)
	}
}
