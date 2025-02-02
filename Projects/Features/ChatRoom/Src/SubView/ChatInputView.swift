//
//  ChatInputView.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import Core
import DSKit

final class ChatInputView: UIControl {
  lazy var attachButton: UIButton = {
    let button = UIButton(frame: .zero)
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.Icons.attach.image
    button.configuration = config
    return button
  }()
  lazy var sendButton: UIButton = {
    let button = UIButton(frame: .zero)
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.Icons.send.image
    button.configuration = config
    return button
  }()
  lazy var textField: UITextView = {
    let textField = UITextView()
    textField.layer.masksToBounds = true
    textField.font = .thtSubTitle2R
    textField.textColor = DSKitAsset.Color.neutral50.color
    textField.backgroundColor = DSKitAsset.Color.neutral600.color
    textField.isScrollEnabled = true
    textField.textContainer.lineFragmentPadding = 0
    textField.textContainerInset = .init(top: 10, left: 10, bottom: 5, right: 10)
    return textField
  }()

  var text: String? {
    set {
      textField.text = newValue
      if textField.isFocused {
        attachButton.configuration?.image = DSKitAsset.Image.Icons.attachSelected.image
        sendButton.configuration?.image = DSKitAsset.Image.Icons.sendSelected.image
      } else {
        attachButton.configuration?.image = DSKitAsset.Image.Icons.attach.image
        sendButton.configuration?.image = DSKitAsset.Image.Icons.send.image
      }
    } get {
      textField.text
    }
  }

  private lazy var lineView: UIView = {
    let view = UIView()
    view.backgroundColor = DSKitAsset.Color.neutral600.color
    return view
  }()

  init() {
    super.init(frame: .zero)
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    self.addSubviews(lineView, attachButton, textField, sendButton)

    lineView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(1)
    }
    attachButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    attachButton.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.centerY.equalToSuperview().offset(1)
    }
//    textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    textField.setContentHuggingPriority(.defaultLow, for: .vertical)
    textField.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().offset(-10)
      $0.height.equalTo(40).priority(.low)
      $0.leading.equalTo(attachButton.snp.trailing)
      $0.trailing.equalTo(sendButton.snp.leading)
    }
    sendButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    sendButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    sendButton.snp.makeConstraints {
      $0.centerY.equalTo(attachButton)
      $0.trailing.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    textField.layer.cornerRadius = textField.frame.height / 2
  }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatInputViewPreview: PreviewProvider {

  static var previews: some View {
      UIViewPreview {
        let view = ChatInputView()

        return view
      }
      .frame(width: UIScreen.main.bounds.width, height: 60)
      .previewLayout(.sizeThatFits)
  }
}
#endif
