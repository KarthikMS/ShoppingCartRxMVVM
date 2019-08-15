//
//  SuccessViewController.swift
//  ShoppingRxMVVM
//
//  Created by Karthik M S on 13/08/19.
//  Copyright © 2019 zoho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SuccessViewController: UIViewController {
	// MARK: - IBOutlets
	@IBOutlet private weak var messageLabel: UILabel!
	
	// MARK: - Properties
	private var viewModel: SuccessViewModel?

	// MARK: - Util
	private let disposeBag = DisposeBag()
}

// MARK: - View Life Cycle
extension SuccessViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		bindRx()
	}
}

// MARK: - Setup
extension SuccessViewController {
	func setUp(shopViewModel: ShopViewModel) {
		self.viewModel = SuccessViewModel(shopViewModel: shopViewModel)
	}

	func bindRx() {
		guard let viewModel = viewModel else {
			assertionFailure()
			return
		}

		viewModel.message
			.asDriver(onErrorJustReturn: "Oops, there seems to be an error.")
			.drive(messageLabel.rx.text)
			.disposed(by: disposeBag)
	}
}
