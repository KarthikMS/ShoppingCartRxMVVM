//
//  PaymentViewModel.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import Foundation
import RxSwift

class PaymentViewModel {
	enum Action {
		case setCreditCardNumber(_ creditCardNumber: String)
		case setCVV(_ cvv: String)
	}

	// MARK: Properties
	let isPayButtonValid = BehaviorSubject<Bool>(value: false)

	// MARK: - Initializers
	init() {
		bindRx()
	}

	// MARK: - Util
	private let disposeBag = DisposeBag()
	private let isCreditCardNumberValid = BehaviorSubject<Bool>(value: false)
	private let isCVVValid = BehaviorSubject<Bool>(value: false)
}

// MARK: - Setup
private extension PaymentViewModel {
	func bindRx() {
		Observable.combineLatest(isCreditCardNumberValid, isCVVValid)
			.subscribe(onNext: { [weak self] in self?.isPayButtonValid.onNext($0 && $1) })
			.disposed(by: disposeBag)
	}
}

// MARK: - Inputs
extension PaymentViewModel {
	func performAction(_ action: Action) {
		switch action {
		case .setCreditCardNumber(let creditCardNumber):
			let creditCardNumberField = CreditCardNumberField(value: creditCardNumber)
			isCreditCardNumberValid.onNext(creditCardNumberField.isValid)
		case .setCVV(let cvv):
			let cvvField = CVVField(value: cvv)
			isCVVValid.onNext(cvvField.isValid)
		}
	}
}
