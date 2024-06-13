//
//  LogViewController.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

open class TFBaseViewController: UIViewController, ViewControllable {
  public var disposeBag = DisposeBag()

  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    TFLogger.cycle(name: self)
  }
  
  open override func loadView() {
    super.loadView()
    
    view.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    
    TFLogger.cycle(name: self)

    makeUI()
    bindViewModel()
    navigationSetting()
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  // MARK: - Open
  open func makeUI() { }

  open func bindViewModel() { }

//  https://ios-development.tistory.com/697
  open func navigationSetting() {
    
    let backButtonImage = DSKitAsset.Image.Icons.chevron.image.withAlignmentRectInsets(.init(top: 0, left: -10, bottom: 0, right: 0))
    
    let backButtonAppearence = UIBarButtonItemAppearance()
    backButtonAppearence.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont.systemFont(ofSize: 0)]
    
    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.titlePositionAdjustment.horizontal = -CGFloat.greatestFiniteMagnitude
    navBarAppearance.titleTextAttributes = [.font: UIFont.thtH4Sb, .foregroundColor: DSKitAsset.Color.neutral50.color]
    navBarAppearance.backgroundColor = DSKitAsset.Color.neutral700.color
    navBarAppearance.shadowColor = .clear
    navBarAppearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
    navBarAppearance.backButtonAppearance = backButtonAppearence
    
    // Bar button title color
    navigationController?.navigationBar.tintColor = DSKitAsset.Color.neutral50.color

    navigationController?.navigationBar.standardAppearance = navBarAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    navigationController?.navigationBar.isTranslucent = false
  }
}
