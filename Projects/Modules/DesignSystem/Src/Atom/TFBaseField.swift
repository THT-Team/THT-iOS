//
//  TFBaseField.swift
//  DSKit
//
//  Created by Kanghos on 7/20/24.
//

import UIKit

import RxCocoa
import RxSwift

public enum TFFieldState {
  case text(text: String?)
  case error(text: String)
}

public enum TFDivderState: Equatable {
  case focus
  case nonFocus
  case error
}

fileprivate enum Color {
  static let focus =  DSKitAsset.Color.primary500.color
  static let nonFocus = DSKitAsset.Color.neutral300.color
  static let error = DSKitAsset.Color.error.color
  static let secondary = DSKitAsset.Color.neutral400.color
}

public protocol TFFieldProtocol {
  associatedtype Action
  associatedtype ViewState: Equatable
  var viewState: ViewState { get set }
  var text: String? { get set }
  var placeholder: String? { get set }
  func send(action: Action)
  func render(_ state: ViewState)
}

public class TFBaseField: UIControl, TFFieldProtocol {
  public enum Action {
    case bind(text: String)
    case focus
    case endFocus
    case error(message: String)
  }

  public struct ViewState: Equatable {
    var dividerState: TFDivderState = .nonFocus
    var errorDescription: String = ""
    var text: String = ""
    var isClearBtnHidden: Bool {
      text.isEmpty
    }
  }

  public var viewState: ViewState {
    willSet {
      if self.viewState != newValue {
        self.render(newValue)
      }
    }
  }

  public var text: String? {
    set {
      if self.text != newValue {
        self.send(action: .bind(text: newValue ?? ""))
        self.textField.sendActions(for: .editingChanged)
      }
    } get {
      self.viewState.text
    }
  }

  public var placeholder: String? {
    set {
      self.textField.placeholder = newValue
      self.textField.setPlaceholderColor(DSKitAsset.Color.disabled.color, font: .thtH3Sb)
    } get {
      self.textField.placeholder
    }
  }

  public private(set) lazy var textField = UITextField().then {
    $0.textColor = Color.focus
    $0.font = .thtH2B
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.spellCheckingType = .no
    $0.tintColor = .clear
  }

  public private(set) lazy var clearBtn: UIButton = UIButton.makeClearBtn()

  public private(set) lazy var divider: UIView = UIView().then {
    $0.backgroundColor = Color.nonFocus
  }
  public private(set) lazy var errorDescriptionLabel = UILabel().then {
    $0.font = .thtCaption1M
    $0.textColor = Color.error
    $0.textAlignment = .left
    $0.numberOfLines = 3
  }

  public init(placeholder: String?) {
    self.viewState = .init()
    super.init(frame: .zero)
    self.placeholder = placeholder
    makeUI()
    bindAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func makeUI() {
    addSubviews(
      textField, clearBtn,
      divider,
      errorDescriptionLabel
    )

    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    textField.snp.makeConstraints {
      $0.top.leading.equalToSuperview()
      $0.height.greaterThanOrEqualTo(40)
      $0.trailing.equalTo(clearBtn.snp.leading)
    }

    clearBtn.snp.makeConstraints {
      $0.centerY.equalTo(textField)
      $0.trailing.equalToSuperview()
      $0.size.equalTo(24)
    }

    divider.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(textField.snp.bottom).offset(2)
      $0.height.equalTo(2)
    }
    errorDescriptionLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(divider.snp.bottom)
      $0.height.greaterThanOrEqualTo(20)
      $0.bottom.equalToSuperview()
    }
  }

  public func bindAction() {
    clearBtn.addAction(UIAction(handler: { [weak self] _ in
      self?.send(action: .bind(text: ""))
      self?.textField.sendActions(for: .editingChanged)
      self?.textField.sendActions(for: .editingDidEnd)
    }), for: .touchUpInside)

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.send(action: .focus)
    }), for: .editingDidBegin)

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.send(action: .endFocus)
    }), for: .editingDidEnd)

    textField.addAction(UIAction(handler: { [weak self] _ in
      self?.send(action: .bind(text: self?.textField.text ?? ""))
      self?.sendActions(for: .editingChanged)
    }), for: .editingChanged)
  }

  @discardableResult
  public override func becomeFirstResponder() -> Bool {
    self.textField.becomeFirstResponder()
  }

  public func send(action: Action) {
    var newState = self.viewState
    switch action {
    case .bind(let text):
      newState.text = text
      newState.dividerState = text.isEmpty ? .nonFocus : .focus
      newState.errorDescription = ""
    case .focus:
      newState.dividerState = .focus
    case .endFocus:
      newState.dividerState = .nonFocus
    case let .error(message):
      newState.dividerState = .error
      newState.errorDescription = message
    }
    self.viewState = newState
  }

  public func render(_ state: ViewState) {
    if textField.text != state.text {
      textField.text = state.text
    }
    clearBtn.isHidden = state.isClearBtnHidden
    errorDescriptionLabel.text = state.errorDescription
    updateDividerColor(state.dividerState)
  }

  public func updateDividerColor(_ state: TFDivderState) {
    switch state {
    case .error:
      self.divider.backgroundColor = Color.error
    case .focus:
      self.divider.backgroundColor = Color.focus
    case .nonFocus:
      if self.divider.backgroundColor != Color.error {
        self.divider.backgroundColor = Color.nonFocus
      }
    }
  }
}

extension Reactive where Base: TFBaseField {
  public var text: ControlProperty<String?> {
    return controlProperty(
      editingEvents: [.editingChanged, .valueChanged],
      getter: { $0.text },
      setter: { base, value in
        if base.text != value {
          base.text = value
        }
      }
    )
  }
}
