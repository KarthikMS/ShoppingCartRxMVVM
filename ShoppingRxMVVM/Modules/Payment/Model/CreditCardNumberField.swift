//
//  CreditCardNumberField.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation

struct CreditCardNumberField {
	// MARK: - Dependencies
	let value: String
}

extension CreditCardNumberField: PaymentField {
	var isValid: Bool {
		return value.count == 16 && value.hasOnlyNumbers
	}
}
