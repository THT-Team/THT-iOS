//
//  LogViewController.swift
//  DSKit
//
//  Created by Kanghos on 2023/12/06.
//

import UIKit

public extension UIButton {
  static func makeBackButton() -> UIButton {
    let button = UIButton()
    button.setImage(DSKitAsset.Image.Icons.chevron.image, for: .normal)
    button.imageView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    return button
  }
}

open class TFBaseViewController: UIViewController, ViewControllable {
  public var disposeBag = DisposeBag()
  private let _backButton = UIButton.makeBackButton()
  open var backButton: UIButton {
    _backButton
  }

  public init() {
    super.init(nibName: nil, bundle: nil)
    TFLogger.cycle(name: self)
  }

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
	
	@available(*, unavailable)
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

  public func addKeyboardDismissGesture() {
    self.view.rx.tapGesture()
      .when(.recognized)
      .subscribe { [weak self] _ in
        self?.view.endEditing(true)
      }.disposed(by: disposeBag)
  }

  public func setBackButton() {
    self.view.addSubview(backButton)
    backButton.addAction(.init { [weak self] _ in
      self?.defaultBackButtonAction()
    }, for: .touchUpInside)

    backButton.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(4)
      $0.leading.equalTo(self.view)//.offset(16.adjusted)
      $0.size.equalTo(56.adjustedH)
    }
  }

  open func defaultBackButtonAction() {
    navigationController?.popViewController(animated: true)
  }
}
