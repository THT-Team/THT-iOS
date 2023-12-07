//
//  LogViewController.swift
//  Core
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

import DSKit

open class TFBaseViewController: UIViewController, ViewControllable {
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }
}
