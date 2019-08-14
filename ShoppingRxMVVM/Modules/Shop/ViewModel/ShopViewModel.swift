//
//  ShopViewModel.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation
import RxSwift

class ShopViewModel {
	enum Action {
		case addItemToCart(_ item: ShoppingItem)
		case removeItemFromCart(_ item: ShoppingItem)
	}

	// MARK: - Dependencies
	private let dataSource: ShopDataSource
	private let shoppingCart: ShoppingCart

	// MARK: - Properties
	var allItems = BehaviorSubject<[ShoppingItem]>(value: [])
	var itemsInCart = BehaviorSubject<[ShoppingItem]>(value: [])

	// MARK: - Util
	private let disposeBag = DisposeBag()

	// MARK: - Initializers
	init(dataSource: ShopDataSource) {
		self.dataSource = dataSource
		allItems.onNext(dataSource.getItems())
		shoppingCart = ShoppingCart()
		bindRx()
	}
}

// MARK: - Setup
private extension ShopViewModel {
	func bindRx() {
		shoppingCart.items.asObservable()
			.bind(to: itemsInCart)
			.disposed(by: disposeBag)
	}
}

// MARK: - Inputs
extension ShopViewModel {
	func performAction(_ action: Action) {
		switch action {
		case .addItemToCart(let item):
			addItemToCart(item)
		case .removeItemFromCart(let item):
			removeItemFromCart(item)
		}
	}

	private func addItemToCart(_ item: ShoppingItem) {
		shoppingCart.addItem(item)
	}

	private func removeItemFromCart(_ item: ShoppingItem) {
		shoppingCart.removeItem(item)
	}
}
