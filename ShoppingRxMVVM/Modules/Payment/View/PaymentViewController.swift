//
//  PaymentViewController.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PaymentViewController: UIViewController {
	// MARK: - IBOutlets
	@IBOutlet private weak var creditCardNumberTextField: UITextField!
	@IBOutlet private weak var cvvTextField: UITextField!
	@IBOutlet private weak var payButton: UIButton!

	// MARK: - Properties
	private let viewModel = PaymentViewModel()

	// MARK: - Util
	private let disposeBag = DisposeBag()
	private let throttleInterval: Int = 300
	private var shopViewModel: ShopViewModel?
}

// MARK: - View Life Cycle
extension PaymentViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Payment"
		bindRx()
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard let identifier = segue.identifier else {
			return
		}
		switch identifier {
		case PaymentToSuccessIdentifier:
			guard let successViewController = segue.destination as? SuccessViewController,
				let shopViewModel = shopViewModel else {
					assertionFailure()
					return
			}
			successViewController.setUp(shopViewModel: shopViewModel)
		default:
			break
		}
	}
}

// MARK: - Setup
extension PaymentViewController {
	func setUp(shopViewModel: ShopViewModel) {
		self.shopViewModel = shopViewModel
	}

	func bindRx() {
		creditCardNumberTextField.rx.text
			.orEmpty
			.throttle(.milliseconds(throttleInterval), scheduler: MainScheduler.instance)
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] in self?.viewModel.performAction(.setCreditCardNumber($0)) })
			.disposed(by: disposeBag)

		cvvTextField.rx.text
			.orEmpty
			.throttle(.milliseconds(throttleInterval), scheduler: MainScheduler.instance)
			.distinctUntilChanged()
			.subscribe(onNext: { [weak self] in self?.viewModel.performAction(.setCVV($0)) })
			.disposed(by: disposeBag)

		viewModel.isPayButtonValid
			.asDriver(onErrorJustReturn: false)
			.do(onNext: { [weak self] isValid in
				let titleColor: UIColor = isValid ? .green : .lightGray
				self?.payButton.setTitleColor(titleColor, for: .normal)
			})
			.drive(payButton.rx.isEnabled)
			.disposed(by: disposeBag)

		payButton.rx.tap
			.subscribe(onNext: { [weak self] in self?.performSegue(withIdentifier: PaymentToSuccessIdentifier, sender: nil) })
			.disposed(by: disposeBag)
	}
}
