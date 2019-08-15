//
//  CVVField.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation

struct CVVField {
	// MARK: - Dependencies
	let value: String
}

extension CVVField: PaymentField {
	var isValid: Bool {
		return value.count == 3 && value.hasOnlyNumbers
	}
}
