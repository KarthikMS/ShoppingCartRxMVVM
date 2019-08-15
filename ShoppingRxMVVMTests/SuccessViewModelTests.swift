//
//  SuccessViewModelTests.swift
//  ShoppingRxMVVMTests
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

@testable import ShoppingRxMVVM
import XCTest

class SuccessViewModelTests: XCTestCase {

	private var shopViewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
	private var viewModel = SuccessViewModel(shopViewModel: ShopViewModel(dataSource: ShopDataSourceImpl()))

	override func setUp() {
		shopViewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
		viewModel = SuccessViewModel(shopViewModel: shopViewModel)

		// Adding items to cart
		do {
			let itemsInShop = try shopViewModel.allItems.value()
			let ball = itemsInShop[1]
			let perfume = itemsInShop[3]
			shopViewModel.performAction(.addItemToCart(ball)) // itemsInCart: 1 ball
			shopViewModel.performAction(.addItemToCart(perfume)) // itemsInCart: 1 ball, 1 perfume
			shopViewModel.performAction(.addItemToCart(ball)) // itemsInCart: 2 balls, 1 perfume
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testMessage() {
		do {
			let message = try viewModel.message.value()
			XCTAssertEqual(message, "Successfully purchased [\"Ball\", \"Perfume\", \"Ball\"].")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

}
