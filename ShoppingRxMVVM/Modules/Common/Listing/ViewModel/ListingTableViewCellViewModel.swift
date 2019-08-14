//
//  ListingTableViewCellViewModel.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 14/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation
import RxSwift

class ListingTableViewCellViewModel {
	enum Action {
		case addItemToCart
		case removeItemFromCart
	}

	// MARK: - Dependencies
	private let shopViewModel: ShopViewModel
	private let item: ShoppingItem

	// MARK: - Properites
	let quantityOfItemsInCartString = BehaviorSubject<String>(value: "0")
	let addButtonEnabled = BehaviorSubject<Bool>(value: true)
	let removeButtonEnabled = BehaviorSubject<Bool>(value: false)

	// MARK: - Initializers
	init(shopViewModel: ShopViewModel, item: ShoppingItem) {
		self.shopViewModel = shopViewModel
		self.item = item
		bindRx()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - Inputs
extension ListingTableViewCellViewModel {
	func performAction(_ action: Action) {
		switch action {
		case .addItemToCart:
			addItemToCart()
		case .removeItemFromCart:
			removeItemFromCart()
		}
	}

	private func addItemToCart() {
		shopViewModel.performAction(.addItemToCart(item))
	}

	private func removeItemFromCart() {
		shopViewModel.performAction(.removeItemFromCart(item))
	}
}

// MARK: - Setup
private extension ListingTableViewCellViewModel {
	func bindRx() {
		shopViewModel.itemsInCart.asObservable()
			.map { $0.filter { [weak self] in
				if let `self` = self {
					return $0.id == self.item.id
				}
				return false
				}
			}
			.flatMap { Observable.just($0.count) }
			.map { String($0) }
			.bind(to: quantityOfItemsInCartString)
			.disposed(by: disposeBag)

		shopViewModel.itemsInCart.asObservable()
			.flatMap { Observable.just( $0.count < 10 ) }
			.bind(to: addButtonEnabled)
			.disposed(by: disposeBag)

		shopViewModel.itemsInCart.asObservable()
			.map { $0.filter { [weak self] in
				if let `self` = self {
					return $0.id == self.item.id
				}
				return false
				}
			}
			.flatMap { Observable.just( !$0.isEmpty ) }
			.bind(to: removeButtonEnabled)
			.disposed(by: disposeBag)
	}
}
