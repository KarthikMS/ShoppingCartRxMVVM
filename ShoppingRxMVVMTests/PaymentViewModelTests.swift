//
//  PaymentViewModelTests.swift
//  ShoppingRxMVVMTests
//
//  Created by Karthik M S on 15/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

@testable import ShoppingRxMVVM
import XCTest

class PaymentViewModelTests: XCTestCase {

	private var viewModel = PaymentViewModel()

    override func setUp() {
        viewModel = PaymentViewModel()
    }

	func testInvalidCreditCardNumberInvalidCVV() {
		viewModel.performAction(.setCreditCardNumber("abc"))
		viewModel.performAction(.setCVV("abc"))

		do {
			let isPaymentValid = try viewModel.isPayButtonValid.value()
			XCTAssertEqual(isPaymentValid, false)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testValidCreditCardNumberInvalidCVV() {
		viewModel.performAction(.setCreditCardNumber("1234123412341234"))
		viewModel.performAction(.setCVV("abc"))

		do {
			let isPaymentValid = try viewModel.isPayButtonValid.value()
			XCTAssertEqual(isPaymentValid, false)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testInvalidCreditCardNumberValidCVV() {
		viewModel.performAction(.setCreditCardNumber("abc"))
		viewModel.performAction(.setCVV("123"))

		do {
			let isPaymentValid = try viewModel.isPayButtonValid.value()
			XCTAssertEqual(isPaymentValid, false)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

	func testValidCreditCardNumberValidCVV() {
		viewModel.performAction(.setCreditCardNumber("1234123412341234"))
		viewModel.performAction(.setCVV("123"))

		do {
			let isPaymentValid = try viewModel.isPayButtonValid.value()
			XCTAssertEqual(isPaymentValid, true)
		} catch {
			assertionFailure(error.localizedDescription)
		}
	}

}
