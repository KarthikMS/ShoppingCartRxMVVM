//
//  StringUtil.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation

extension String {
	var hasOnlyNumbers: Bool {
		return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
	}
}
