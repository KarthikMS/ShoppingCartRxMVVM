//
//  CartViewModel.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 14/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation
import RxSwift

class CartViewModel {
	enum Action {
		case emptyCart
	}

	// MARK: - Dependencies
	let shopViewModel: ShopViewModel

	// MARK: - Properties
	let items = BehaviorSubject<[ShoppingItem]>(value: [])
	let totalAmountString = BehaviorSubject<String>(value: "")
	let shouldReturnToShop = BehaviorSubject<Bool>(value: false)

	// MARK: - Initializers
	init(shopViewModel: ShopViewModel) {
		self.shopViewModel = shopViewModel
		bindRx()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - Setup
private extension CartViewModel {
	func bindRx() {
		shopViewModel.itemsInCart
			.subscribe(onNext: { [weak self] itemsInCart in
				let uniqueItemsInCart = itemsInCart.reduce([], { (uniqueItems, item) -> [ShoppingItem] in
					var mutableUniqueItems = uniqueItems
					if !uniqueItems.contains(where: { $0.id == item.id }) {
						mutableUniqueItems.append(item)
					}
					return mutableUniqueItems
				})
				self?.items.onNext(uniqueItemsInCart)
			})
			.disposed(by: disposeBag)

		shopViewModel.itemsInCart
			.subscribe(onNext: { [weak self] items in
				let totalAmount = items.reduce(0, { total, item in total + item.price })
				self?.totalAmountString.onNext("Total: \(totalAmount)")
			})
			.disposed(by: disposeBag)

		shopViewModel.itemsInCart
			.flatMap { Observable.just($0.isEmpty) }
			.bind(to: shouldReturnToShop)
			.disposed(by: disposeBag)

	}
}

// MARK: - Inputs
extension CartViewModel {
	func performAction(_ action: Action) {
		switch action {
		case .emptyCart:
			shopViewModel.performAction(.emptyCart)
		}
	}
}
