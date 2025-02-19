//
//  TFAlertContentView.swift
//  DSKit
//
//  Created by SeungMin on 4/29/24.
//

import UIKit

public typealias TFUserAlertContentView = TFAlertContentView<UserReport>

public final class TFAlertContentView<MenuType>: TFBaseView where MenuType: MenuProtocol {
  var didSelectMenu: ((MenuProtocol) -> Void)?

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public init() {
    super.init(frame: .zero)
  }

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    return stackView
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = MenuType.title
    label.font = UIFont.thtH5Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.numberOfLines = 0
    return label
  }()
  
  let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    return stackView
  }()
  
  public override func makeUI() {
    addSubview(stackView)
    stackView.addArrangedSubviews([titleLabel, buttonStackView])
    
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    buttonStackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
    }

    buttonStackView.addArrangedSubviews(makeMenuButton())

    buttonStackView.arrangedSubviews.forEach { view in
      view.snp.makeConstraints {
        $0.height.equalTo(41)
      }
    }
  }

  private func makeMenuButton() -> [UIButton] {
    MenuType.menuList.map { menu in
      let button = UIButton.createAlertButton(title: menu.label)
      button.addAction(UIAction { [weak self] _ in
        self?.didSelectMenu?(menu)
      }, for: .touchUpInside)
      return button
    }
  }
}

fileprivate extension UIButton {
  static func createAlertButton(title: String) -> UIButton {
    let button = UIButton()
    button.titleLabel?.font = UIFont.thtSubTitle2R
    button.setTitle(title, for: .normal)
    button.setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    button.setBackgroundColor(DSKitAsset.Color.neutral600.color, for: .normal)
    return button
  }
}
