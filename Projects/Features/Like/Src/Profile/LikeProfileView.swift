//
//  ProfileView.swift
//  Falling
//
//  Created by Kanghos on 2023/10/05.
//

import UIKit
import Core
import DSKit

public final class LikeButtonView: TFBaseView {

  lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    stackView.addArrangedSubviews([nextTimeButton, chatButton])
    return stackView
  }()

  lazy var nextTimeButton: UIButton = .makeCapsuleButton(type: .disLike)
  lazy var chatButton: UIButton = .makeCapsuleButton(type: .chat)

  public override func makeUI() {
    self.backgroundColor = .clear

    addSubview(stackView)

    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(46.f)
    }
  }
}


