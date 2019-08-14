//
//  ShoppingItem.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation

typealias Label = Character

struct ShoppingItem {
	let name: String
	let price: Int
	let label: Label
	let id: String
}

extension ShoppingItem {
	var priceString: String {
		return "Rs. \(price)"
	}
}
