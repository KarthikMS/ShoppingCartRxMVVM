//
//  CartViewModelTests.swift
//  ShoppingRxMVVMTests
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

@testable import ShoppingRxMVVM
import XCTest

class CartViewModelTests: XCTestCase {

	private var shopViewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
	private var viewModel = CartViewModel(shopViewModel: ShopViewModel(dataSource: ShopDataSourceImpl()))

    override func setUp() {
		shopViewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
		viewModel = CartViewModel(shopViewModel: shopViewModel)
    }

	func testInitialState() {
		do {
			let items = try viewModel.items.value()
			let totalAmountString = try viewModel.totalAmountString.value()
			let shouldReturnToShop = try viewModel.shouldReturnToShop.value()
			XCTAssert(items.isEmpty)
			XCTAssertEqual(totalAmountString, "0")
			XCTAssertEqual(shouldReturnToShop, true)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testStateWithItemsInCart() {
		do {
			// Adding items to cart
			let itemsInShop = try shopViewModel.allItems.value()
			let ball = itemsInShop[1]
			let perfume = itemsInShop[3]
			shopViewModel.performAction(.addItemToCart(ball)) // itemsInCart: 1 ball
			shopViewModel.performAction(.addItemToCart(perfume)) // itemsInCart: 1 ball, 1 perfume
			shopViewModel.performAction(.addItemToCart(ball)) // itemsInCart: 2 balls, 1 perfume

			// Testing state
			let items = try viewModel.items.value()
			let totalAmountString = try viewModel.totalAmountString.value()
			let shouldReturnToShop = try viewModel.shouldReturnToShop.value()
			XCTAssertEqual(items.count, 2)
			XCTAssertEqual(items[0].id, ball.id)
			XCTAssertEqual(items[1].id, perfume.id)
			XCTAssertEqual(totalAmountString, "90")
			XCTAssertEqual(shouldReturnToShop, false)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testRemovingOneItem() {
		do {
			testStateWithItemsInCart()

			// Removing item from cart
			let itemsInShop = try shopViewModel.allItems.value()
			let ball = itemsInShop[1]
			let perfume = itemsInShop[3]
			shopViewModel.performAction(.removeItemFromCart(ball)) // itemsInCart: 1 ball, 1 perfume

			// Testing state
			let items = try viewModel.items.value()
			let totalAmountString = try viewModel.totalAmountString.value()
			let shouldReturnToShop = try viewModel.shouldReturnToShop.value()
			XCTAssertEqual(items.count, 2)
			XCTAssertEqual(items[0].id, ball.id)
			XCTAssertEqual(items[1].id, perfume.id)
			XCTAssertEqual(totalAmountString, "70")
			XCTAssertEqual(shouldReturnToShop, false)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testRemovingAllItemsOneByOne() {
		do {
			testStateWithItemsInCart()

			// Removing items from cart
			let itemsInShop = try shopViewModel.allItems.value()
			let ball = itemsInShop[1]
			let perfume = itemsInShop[3]
			shopViewModel.performAction(.removeItemFromCart(ball)) // itemsInCart: 1 ball, 1 perfume
			shopViewModel.performAction(.removeItemFromCart(ball)) // itemsInCart: 1 perfume
			shopViewModel.performAction(.removeItemFromCart(perfume)) // itemsInCart: EMPTY

			// Testing state
			let items = try viewModel.items.value()
			let totalAmountString = try viewModel.totalAmountString.value()
			let shouldReturnToShop = try viewModel.shouldReturnToShop.value()
			XCTAssert(items.isEmpty)
			XCTAssertEqual(totalAmountString, "0")
			XCTAssertEqual(shouldReturnToShop, true)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testEmptyCart() {
		do {
			testStateWithItemsInCart()

			// Emptying cart
			viewModel.performAction(.emptyCart)

			// Testing state
			let items = try viewModel.items.value()
			let totalAmountString = try viewModel.totalAmountString.value()
			let shouldReturnToShop = try viewModel.shouldReturnToShop.value()
			XCTAssert(items.isEmpty)
			XCTAssertEqual(totalAmountString, "0")
			XCTAssertEqual(shouldReturnToShop, true)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

}
