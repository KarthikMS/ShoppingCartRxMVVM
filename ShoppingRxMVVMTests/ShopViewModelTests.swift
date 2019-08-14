//
//  ShopViewModelTests.swift
//  ShoppingRxMVVMTests
//
//  Created by Karthik M S on 14/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

@testable import ShoppingRxMVVM
import XCTest

class ShopViewModelTests: XCTestCase {

	private var viewModel = ShopViewModel(dataSource: ShopDataSourceImpl())

    override func setUp() {
		viewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
    }

	func testInitialViewModelState() {
		do {
			let allItems = try viewModel.allItems.value()
			let itemsInCart = try viewModel.itemsInCart.value()
			XCTAssertEqual(allItems.count, 4, "Incorrect number of items: \(allItems.count)")
			XCTAssert(itemsInCart.isEmpty)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testAddItemToCart() {
		do {
			let allItems = try viewModel.allItems.value()

			// Adding item to cart
			let itemToAdd = allItems[0]
			viewModel.performAction(.addItemToCart(itemToAdd))

			// Testing
			let itemsInCart = try viewModel.itemsInCart.value()
			XCTAssertEqual(itemsInCart.count, 1, "Item not added to cart. \(itemsInCart.count)")
			XCTAssertEqual(itemsInCart[0].id, itemToAdd.id, "Incorrect item added: \(itemsInCart[0].id)")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testRemovingItemFromCart() {
		do {
			let allItems = try viewModel.allItems.value()

			// Adding item to cart
			let itemToRemove = allItems[0]
			viewModel.performAction(.addItemToCart(itemToRemove))

			// Removing item from cart
			viewModel.performAction(.removeItemFromCart(itemToRemove))

			// Testing
			let itemsInCart = try viewModel.itemsInCart.value()
			XCTAssert(itemsInCart.isEmpty, "Item not added to cart. \(itemsInCart.count)")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

}
