//
//  TFTextField.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit
import RxCocoa

public enum InputError: Error {
  case validate(text: String)
  case overflow
}

public class TFTextField: UIControl, TFFieldProtocol {
  
  public enum Action {
    case bind(text: String)
    case focus
    case endFocus
    case error(text: String)
  }

  public struct ViewState: Equatable {
    var fieldState: TFBaseField.ViewState
  }

  public var viewState: ViewState {
    willSet {
      if self.viewState != newValue {
        self.render(newValue)
      }
    }
  }
  public var placeholder: String? {
    didSet {
      self.textField.placeholder = placeholder
    }
  }

  public var text: String? {
    set {
      if self.text != newValue {
        self.send(action: .bind(text: newValue ?? ""))
        self.textField.sendActions(for: .valueChanged)
      }
    } get {
      self.viewState.fieldState.text
    }
  }

  public private(set) lazy var textField = TFBaseField(placeholder: "")

  public private(set) lazy var descriptionView = TFMultiLineDescriptionView(description: descriptionText)

  private let descriptionText: String

  public init(
    description: String,
    placeholder: String) {
      self.viewState = .init(fieldState: .init())
      self.descriptionText = description
      super.init(frame: .zero)
      self.textField.placeholder = placeholder
      makeUI()
    }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func makeUI() {
    addSubviews(
      textField,
      descriptionView
    )

    textField.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }

    descriptionView.snp.makeConstraints {
      $0.leading.equalTo(textField)
      $0.trailing.bottom.equalToSuperview()
      $0.top.equalTo(textField.snp.bottom)
    }
  }

  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    self.textField.becomeFirstResponder()
  }

  public func send(action: Action) {
    var newState = self.viewState
    switch action {
    case .bind(let text):
      newState.fieldState.text = text
    case .focus:
      newState.fieldState.dividerState = .focus
    case .endFocus:
      newState.fieldState.dividerState = .nonFocus
    case let .error(message):
      newState.fieldState.dividerState = .error
      newState.fieldState.errorDescription = message
    }
    self.viewState = newState
  }

  public func render(_ state: ViewState) {
    if self.textField.text != state.fieldState.text {
      self.textField.render(state.fieldState)
    }
  }
}

extension Reactive where Base: TFTextField {
  public var text: ControlProperty<String?> {
    return base.textField.rx.text
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFTextFieldPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      let component = TFTextField(description: "닉네임 입력해줘", placeholder: "a")
      return component
    }
    .frame(width: .infinity, height: 100)
    .previewLayout(.sizeThatFits)
  }
}
#endif
