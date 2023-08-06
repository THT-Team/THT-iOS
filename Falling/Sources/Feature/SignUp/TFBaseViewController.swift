//
//  TFBaseViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/08/03.
//

import UIKit

import RxSwift

class TFBaseViewController: UIViewController {
	
	var disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = FallingAsset.Color.netural700.color
		navigationSetting()
		makeUI()
		bindViewModel()
	}
	
	/// call in super viewDidLoad
	func makeUI() { }
	
	/// call in super viewDidLoad
	func bindViewModel() { }
	
	func navigationSetting() {
		navigationController?.navigationBar.topItem?.title = ""
		navigationController?.navigationBar.backIndicatorImage = FallingAsset.Image.chevron.image
		navigationController?.navigationBar.backIndicatorTransitionMaskImage = FallingAsset.Image.chevron.image
		navigationController?.navigationBar.tintColor = FallingAsset.Color.netural50.color
	}
}
