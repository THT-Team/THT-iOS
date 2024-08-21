//
//  TFResizableTextView.swift
//  SignUp
//
//  Created by kangho lee on 4/27/24.
//

import UIKit

import RxSwift

import SnapKit

public class TFBaseTextView: UIControl, TFFieldProtocol {
  public var placeholder: String?

  private enum Color {
    static let focus =  DSKitAsset.Color.primary500.color
    static let nonFocus = DSKitAsset.Color.neutral300.color
    static let error = DSKitAsset.Color.error.color
    static let secondary = DSKitAsset.Color.neutral400.color
  }

  public enum Action {
    case bind(text: String?)
    case error(message: String)
    case focus
    case endFocus(text: String?)
  }

  public struct ViewState: Equatable {
    var isPlaceholderHidden: Bool = false
    var dividerState: TFDivderState = .nonFocus
    var errorDescription: String? = nil
    var text: String? = nil
    var isClearBtnHidden: Bool {
      text?.isEmpty ?? true
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
        self.send(action: .bind(text: newValue))
      }
    } get {
      return self.viewState.text
    }
  }

  private lazy var placeholderLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.disabled.color
    $0.font = .thtSubTitle1R
    $0.backgroundColor = .clear
  }

  public lazy var textView = ResizableTextView().then {
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtSubTitle1R
    $0.isScrollEnabled = false
    $0.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    $0.textContainer.lineFragmentPadding = 0
    $0.isEditable = true
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }

  lazy var clearBtn = UIButton.makeClearBtn()

  lazy var divider: UIView = UIView().then {
    $0.backgroundColor = Color.nonFocus
  }

  lazy var errorDescriptionLabel = UILabel().then {
    $0.font = .thtCaption1M
    $0.textColor = Color.error
    $0.textAlignment = .left
    $0.numberOfLines = 3
  }

  public init(placeholder: String? = nil) {
    self.viewState = ViewState()
    super.init(frame: .zero)
    self.placeholderLabel.text = placeholder
    makeUI()
    bindAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeUI() {
    addSubviews(
      textView, clearBtn,
      placeholderLabel,
      divider,
      errorDescriptionLabel
    )

    textView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(clearBtn.snp.leading)
    }

    clearBtn.snp.makeConstraints {
      $0.leading.equalTo(textView.snp.trailing)
      $0.bottom.equalTo(textView).offset(-((40 - 24) / 2))
      $0.trailing.equalToSuperview()
      $0.size.equalTo(24)
    }

    placeholderLabel.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(textView)
      $0.height.equalTo(40)
    }

    divider.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(textView.snp.bottom).offset(2)
      $0.height.equalTo(2)
    }

    errorDescriptionLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(divider.snp.bottom)
      $0.height.greaterThanOrEqualTo(20)
      $0.bottom.equalToSuperview()
    }
  }

  func bindAction() {
    textView.delegate = self

    clearBtn.addAction(UIAction(handler: { [weak self] _ in
      self?.send(action: .bind(text: nil))
      guard let self else { return }
      self.textViewDidChange(self.textView)
      self.textViewDidEndEditing(self.textView)
    }), for: .touchUpInside)
  }

  public func send(action: Action) {
    var newState = self.viewState
    switch action {
    case let .bind(text):
      newState.errorDescription = nil
      newState.isPlaceholderHidden = true
      newState.text = text
      newState.dividerState = .focus

    case .focus:
      newState.dividerState = .focus
      newState.isPlaceholderHidden = true
    case let .endFocus(text):
      newState.dividerState = .error
      newState.isPlaceholderHidden = (text?.isEmpty ?? true) == false
    case .error(let message):
      newState.errorDescription = message
      newState.dividerState = .error
    }
    self.viewState = newState
  }

  public func render(_ state: ViewState) {
    if self.textView.text != state.text {
      self.textView.text = state.text
    }
    self.errorDescriptionLabel.text = state.errorDescription
    self.updateDividerColor(state.dividerState)
    self.clearBtn.isHidden = state.isClearBtnHidden
    self.placeholderLabel.isHidden = state.isPlaceholderHidden
  }

  private func updateDividerColor(_ state: TFDivderState) {
    switch state {
    case .error:
      if self.divider.backgroundColor != Color.error {
        self.divider.backgroundColor = Color.nonFocus
      }
    case .focus:
      self.divider.backgroundColor = Color.focus
    case .nonFocus:
      self.divider.backgroundColor = Color.nonFocus
    }
  }
}

extension TFBaseTextView: UITextViewDelegate {
  public func textViewDidBeginEditing(_ textView: UITextView) {
    send(action: .focus)
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    send(action: .endFocus(text: textView.text))
  }

  public func textViewDidChange(_ textView: UITextView) {
    send(action: .bind(text: textView.text))
    self.textView.calculate()
  }
}
extension Reactive where Base: TFBaseTextView {
  public var text: ControlProperty<String?> {
    self.base.textView.rx.text
  }
}
