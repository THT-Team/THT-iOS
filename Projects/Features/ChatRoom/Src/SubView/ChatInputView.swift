//
//  ChatInputView.swift
//  Chat
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import Core
import DSKit

final class ChatInputView: UIView {
  lazy var attachButton: UIButton = {
    let button = UIButton(frame: .zero)
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.Icons.attach.image
    button.configuration = config
    return button
  }()
  lazy var sendButton: UIButton = {
    let button = UIButton()
    button.setImage(DSKitAsset.Image.Icons.send.image, for: .normal)
//    var config = UIButton.Configuration.plain()
//    config.image = DSKitAsset.Image.Icons.send.image
//    button.configuration = config
    return button
  }()
  lazy var field: UITextView = {
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
    get {
      field.text
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
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    self.addSubviews(lineView, field, sendButton)

    lineView.snp.makeConstraints {
      $0.leading.trailing.top.equalToSuperview()
      $0.height.equalTo(1)
    }

    field.snp.makeConstraints {
      $0.top.equalTo(lineView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().offset(-10)
      $0.height.equalTo(40).priority(.low)
      $0.leading.equalToSuperview().offset(10)
    }
    sendButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.width.equalTo(50)
      $0.leading.equalTo(field.snp.trailing)
      $0.height.equalTo(40)
      $0.trailing.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    field.layer.cornerRadius = field.frame.height / 2
  }

  func bind() {
    field.delegate = self
  }
}

extension ChatInputView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    sendButton.isEnabled = true // !textView.text.isEmpty
    let image = textView.text.isEmpty
    ? DSKitAsset.Image.Icons.send.image
    : DSKitAsset.Image.Icons.sendSelected.image
    sendButton.setImage(image, for: .normal)
  }
}

extension Reactive where Base: ChatInputView {
  var sendButtonTap: ControlEvent<String> {
    let source: Observable<String> = base.sendButton.rx.tap
      .withLatestFrom(self.base.field.rx.text.orEmpty)
        .flatMap { text -> Observable<String> in
          if !text.isEmpty {
            return .just(text)
          } else {
            return .empty()
          }
        }
        .do(onNext: { [weak base = self.base] _ in
          base?.field.text = nil
        })
      return ControlEvent(events: source)
    }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatInputViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
      UIViewPreview {
        let view = ChatInputView()

        return view
      }
      .frame(width: UIScreen.main.bounds.width, height: 60)
      .previewLayout(.sizeThatFits)
  }
}
#endif
