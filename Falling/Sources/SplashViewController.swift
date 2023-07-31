//
//  SplashViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import UIKit

import SnapKit
import Then

final class SplashViewController: UIViewController {
	
	private lazy var temporaryLabel: UILabel = UILabel().then {
		$0.translatesAutoresizingMaskIntoConstraints = false
		$0.text = "Splash View"
		$0.textColor = .white
		$0.font = .boldSystemFont(ofSize: 20)
	}
	
	override func loadView() {
		super.loadView()
		self.view.addSubview(temporaryLabel)
		temporaryLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = .white
		self.changeMainView()
    }
	
	func changeMainView() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
			let rootViewController = SignUpRootViewController()
			let naviController = UINavigationController(rootViewController: rootViewController)
			
			let keyWindow = UIApplication.shared.connectedScenes
				.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
				.last { $0.isKeyWindow }
			keyWindow?.rootViewController = naviController
		}
	}
}
