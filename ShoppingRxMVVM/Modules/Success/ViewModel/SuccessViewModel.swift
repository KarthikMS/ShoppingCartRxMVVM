//
//  SuccessViewModel.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation
import RxSwift

class SuccessViewModel {
	// MARK: - Dependencies
	let shopViewModel: ShopViewModel

	// MARK: Properties
	let message = BehaviorSubject<String>(value: "")

	// MARK: - Initializers
	init(shopViewModel: ShopViewModel) {
		self.shopViewModel = shopViewModel
		bindRx()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - Setup
private extension SuccessViewModel {
	func bindRx() {
		shopViewModel.itemsInCart
			.asObserver()
			.subscribe(onNext: { [weak self] in
				if let `self` = self {
					self.message.onNext(self.successMessage(for: $0))
				}
			})
			.disposed(by: disposeBag)
	}
}

// MARK: - Util
private extension SuccessViewModel {
	func successMessage(for items: [ShoppingItem]) -> String {
		return "Successfully purchased \(items.map { $0.name })."
	}
}
