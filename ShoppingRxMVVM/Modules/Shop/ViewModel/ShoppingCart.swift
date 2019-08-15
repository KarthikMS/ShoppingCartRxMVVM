//
//  ShoppingCart.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 14/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation
import RxSwift

class ShoppingCart {

	var items = BehaviorSubject<[ShoppingItem]>(value: [])

	/// Adds one item
	func addItem(_ item: ShoppingItem) {
		do {
			var newValue = try items.value()
			newValue.append(item)
			items.onNext(newValue)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	/// Removes one item
	func removeItem(_ item: ShoppingItem) {
		do {
			var newValue = try items.value()
			if let index = newValue.lastIndex(where: { $0.id == item.id }) {
				newValue.remove(at: index)
				items.onNext(newValue)
			}
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func emptyCart() {
		items.onNext([])
	}

}
