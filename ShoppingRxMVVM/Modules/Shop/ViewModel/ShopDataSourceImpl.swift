//
//  ShopDataSourceImplementation.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation

class ShopDataSourceImpl: ShopDataSource {
	func getItems() -> [ShoppingItem] {
		return [
			ShoppingItem(name: "Apple", price: 10, label: "A", id: UUID().uuidString),
			ShoppingItem(name: "Ball", price: 20, label: "B", id: UUID().uuidString),
			ShoppingItem(name: "Toy", price: 100, label: "T", id: UUID().uuidString),
			ShoppingItem(name: "Perfume", price: 50, label: "P", id: UUID().uuidString)
		]
	}
}
