//
//  SplashViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import UIKit

import SnapKit
import Then
import Lottie

final class SplashViewController: UIViewController {
	
	private lazy var splashLottieView: LottieAnimationView = .init(name: "logo_splash")
	
	override func loadView() {
		super.loadView()
		self.view.addSubview(splashLottieView)
		splashLottieView.snp.makeConstraints {
			$0.center.equalToSuperview()
			$0.height.width.equalTo(view.bounds.height * 0.7)
		}
		
		splashLottieView.play()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = FallingAsset.Color.netural700.color
		self.changeMainView()
	}
	
	func changeMainView() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			let keyWindow = UIApplication.shared.connectedScenes
				.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
				.last { $0.isKeyWindow }
			Application.shared.configurationMainInterface(window: keyWindow)
		}
	}
}
