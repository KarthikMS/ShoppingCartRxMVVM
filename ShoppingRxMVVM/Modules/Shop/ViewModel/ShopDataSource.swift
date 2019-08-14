//
//  ShopDataSource.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation

protocol ShopDataSource {
	func getItems() -> [ShoppingItem]
}
