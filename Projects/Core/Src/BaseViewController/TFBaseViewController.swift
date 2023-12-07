//
//  LogViewController.swift
//  Core
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import DSKit
import RxSwift

open class TFBaseViewController: UIViewController, ViewControllable {
  var disposeBag = DisposeBag()

  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    
    TFLogger.ui.debug("\(#function) \(type(of: self))")
    self.view.backgroundColor = DSKitAsset.Color.neutral700.color
    makeUI()
    bindViewModel()
    navigationSetting()
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  // MARK: - Open
  open func makeUI() { }

  open func bindViewModel() { }

  open func navigationSetting() {
    navigationController?.navigationBar.topItem?.title = ""
    navigationController?.navigationBar.backIndicatorImage = DSKitAsset.Image.chevron.image
    navigationController?.navigationBar.backIndicatorTransitionMaskImage = DSKitAsset.Image.chevron.image
    navigationController?.navigationBar.tintColor = DSKitAsset.Color.neutral50.color

    let navBarAppearance = UINavigationBarAppearance()
    navBarAppearance.titlePositionAdjustment.horizontal = -CGFloat.greatestFiniteMagnitude
    navBarAppearance.titleTextAttributes = [.font: UIFont.thtH4Sb, .foregroundColor: DSKitAsset.Color.neutral50.color]
    navBarAppearance.backgroundColor = DSKitAsset.Color.neutral700.color
    navBarAppearance.shadowColor = nil
    navigationItem.standardAppearance = navBarAppearance
    navigationItem.scrollEdgeAppearance = navBarAppearance
  }
}
