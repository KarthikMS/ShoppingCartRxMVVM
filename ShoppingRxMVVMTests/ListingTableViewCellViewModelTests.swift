//
//  ListingTableViewCellViewModelTests.swift
//  ShoppingRxMVVMTests
//
//  Created by Karthik M S on 14/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

@testable import ShoppingRxMVVM
import XCTest

class ListingTableViewCellViewModelTests: XCTestCase {

	private var shopViewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
	private var item = ShoppingItem(name: "", price: -1, label: "0", id: "")
	private var viewModel = ListingTableViewCellViewModel(
		shopViewModel: ShopViewModel(dataSource: ShopDataSourceImpl()),
		item: ShoppingItem(name: "", price: -1, label: "0", id: "")
	)

	override func setUp() {
		shopViewModel = ShopViewModel(dataSource: ShopDataSourceImpl())
		do {
			item = try shopViewModel.allItems.value()[0]
			viewModel = ListingTableViewCellViewModel(shopViewModel: shopViewModel, item: item)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testInitialState() {
		do {
			let addButtonEnabled = try viewModel.addButtonEnabled.value()
			let removeButtonEnabled = try viewModel.removeButtonEnabled.value()
			let quantityOfItemsInCartString = try viewModel.quantityOfItemsInCartString.value()
			XCTAssertEqual(addButtonEnabled, true)
			XCTAssertEqual(removeButtonEnabled, false)
			XCTAssertEqual(quantityOfItemsInCartString, "0")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testAddToCart() {
		viewModel.performAction(.addItemToCart)

		do {
			let addButtonEnabled = try viewModel.addButtonEnabled.value()
			let removeButtonEnabled = try viewModel.removeButtonEnabled.value()
			let quantityOfItemsInCartString = try viewModel.quantityOfItemsInCartString.value()
			XCTAssertEqual(addButtonEnabled, true)
			XCTAssertEqual(removeButtonEnabled, true)
			XCTAssertEqual(quantityOfItemsInCartString, "1")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testRemoveFromCart() {
		viewModel.performAction(.addItemToCart)
		viewModel.performAction(.removeItemFromCart)

		do {
			let addButtonEnabled = try viewModel.addButtonEnabled.value()
			let removeButtonEnabled = try viewModel.removeButtonEnabled.value()
			let quantityOfItemsInCartString = try viewModel.quantityOfItemsInCartString.value()
			XCTAssertEqual(addButtonEnabled, true)
			XCTAssertEqual(removeButtonEnabled, false)
			XCTAssertEqual(quantityOfItemsInCartString, "0")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	/// Testing if addToCartButton is disabled when 10 items are in cart.
	func testAddButtonIsEnabled() {
		viewModel.performAction(.addItemToCart) // 1
		viewModel.performAction(.addItemToCart) // 2
		viewModel.performAction(.addItemToCart) // 3
		viewModel.performAction(.addItemToCart) // 4
		viewModel.performAction(.addItemToCart) // 5
		viewModel.performAction(.addItemToCart) // 6
		viewModel.performAction(.addItemToCart) // 7
		viewModel.performAction(.addItemToCart) // 8
		viewModel.performAction(.addItemToCart) // 9
		viewModel.performAction(.addItemToCart) // 10

		do {
			let addButtonEnabled = try viewModel.addButtonEnabled.value()
			let removeButtonEnabled = try viewModel.removeButtonEnabled.value()
			let quantityOfItemsInCartString = try viewModel.quantityOfItemsInCartString.value()
			XCTAssertEqual(addButtonEnabled, false)
			XCTAssertEqual(removeButtonEnabled, true)
			XCTAssertEqual(quantityOfItemsInCartString, "10")
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

}
