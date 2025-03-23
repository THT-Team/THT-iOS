//
//  TFResizableTextView.swift
//  SignUp
//
//  Created by kangho lee on 4/27/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit

public class TFResizableTextView: UIControl {

  private enum Color {
    static let focus =  DSKitAsset.Color.primary500.color
    static let nonFocus = DSKitAsset.Color.neutral300.color
    static let error = DSKitAsset.Color.error.color
    static let secondary = DSKitAsset.Color.neutral400.color
  }

  public enum Action {
    case bind(text: String?)
    case error(error: InputError)
    case focus
    case endFocus(text: String?)
  }

  public struct ViewState: Equatable {
    var isClearBtnHidden: Bool = true
    var isPlaceholderHidden: Bool = false
    var dividerState: TFDivderState = .nonFocus
    var errorDescription: String? = nil
    var text: String? = nil
  }

  public struct Prop {
    let description: String
    let placeHolder: String?
    let maxLength: Int
  }

  let prop: Prop

  public var viewState: TFResizableTextView.ViewState {
    willSet {
      if self.viewState != newValue {
        self.render(newValue)
      }
    }
  }

  public var text: String? {
    set {
      if self.text != newValue {
        self.bind(action: .bind(text: newValue))
        checkOverflow(text: textView.text, maxLength: prop.maxLength)
        self.calculateCount(count: textView.text.count, maxLength: prop.maxLength)
        self.textView.calculate()
        self.sendActions(for: .valueChanged)
      }
    } get {
      return self.viewState.text
    }
  }

  private lazy var placeholderLabel = UILabel().then {
    $0.textColor = DSKitAsset.Color.disabled.color
    $0.font = .thtSubTitle1R
    $0.backgroundColor = .clear
    $0.text = self.prop.placeHolder
  }

  public lazy var textView = ResizableTextView().then {
    $0.textColor = DSKitAsset.Color.primary500.color
    $0.font = .thtSubTitle1R
    $0.isScrollEnabled = false
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

  lazy var descriptionView = TFOneLineDescriptionView(description: prop.description)

  lazy var countLabel = UILabel().then {
    $0.text = "(0/\(prop.maxLength)"
    $0.font = .thtCaption1R
    $0.textColor = DSKitAsset.Color.neutral400.color
    $0.textAlignment = .left
    $0.numberOfLines = 2
  }

  public init(description: String = "asdf", totalCount: Int = 20, placeholder: String? = nil) {
    self.viewState = ViewState()
    self.prop = Prop(description: description, placeHolder: placeholder, maxLength: totalCount)
    super.init(frame: .zero)

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
      errorDescriptionLabel,
      descriptionView, countLabel
    )

    textView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.trailing.equalTo(clearBtn.snp.leading)
    }

    clearBtn.snp.makeConstraints {
      $0.leading.equalTo(textView.snp.trailing)
      $0.bottom.equalTo(textView)
      $0.trailing.equalToSuperview()
      $0.height.equalTo(40)
      $0.width.equalTo(24)
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
      $0.height.equalTo(20).priority(.low)
    }
    descriptionView.snp.makeConstraints {
      $0.top.equalTo(errorDescriptionLabel.snp.bottom)
      $0.leading.equalTo(textView)
      $0.trailing.equalTo(countLabel.snp.leading)
      $0.bottom.equalToSuperview()
    }

    countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    countLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview()
      $0.height.greaterThanOrEqualTo(20)
      $0.bottom.equalToSuperview()
    }
  }

  func bindAction() {
    textView.delegate = self

    clearBtn.addAction(UIAction(handler: { [weak self] _ in
      self?.bind(action: .bind(text: nil))
      guard let self else { return }
      self.textViewDidChange(self.textView)
    }), for: .touchUpInside)
  }

  private func calculateCount(count: Int, maxLength: Int) {
    let fullText = "(\(count)/\(maxLength))"
    let target = "\(count)"
    self.countLabel.attributedText = fullText.asFont(target: target, font: .thtCaption1B)
  }

  func bind(action: Action) {
    var newState = self.viewState
    switch action {
    case let .bind(text):
      newState.errorDescription = nil
      newState.isPlaceholderHidden = true
      newState.text = text
      newState.isClearBtnHidden = text?.isEmpty ?? true
      newState.dividerState = .focus

    case .focus:
      newState.dividerState = .focus
    case let .endFocus(text):
      newState.dividerState = newState.errorDescription == nil ? .nonFocus : .error
      newState.isPlaceholderHidden = (text?.isEmpty ?? true) == false
    case .error(let inputError):
      newState = self.updateErrorView(inputError, state: newState)
    }
    self.viewState = newState
  }

  func render(_ state: ViewState) {
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
      self.divider.backgroundColor = Color.error
    case .focus:
      self.divider.backgroundColor = Color.focus
    case .nonFocus:
      self.divider.backgroundColor = Color.nonFocus
    }
  }

  private func updateErrorView(_ inputError: InputError, state: ViewState) -> ViewState {
    var newState = state
    newState.dividerState = .error
    switch inputError {
    case .validate(let text):
      newState.errorDescription = text
    case .overflow:
      newState.errorDescription = "\(prop.maxLength)자 이상 입력할 수 없습니다."
      let text = newState.text ?? ""
      let endIndex = text.index(text.startIndex, offsetBy: prop.maxLength)
      let range = text[text.startIndex..<endIndex]
      newState.text = String(range)
    }
    return newState
  }

  private func checkOverflow(text: String, maxLength: Int) {
    if text.count > maxLength {
      self.bind(action: .error(error: .overflow))
    }
  }
}

extension TFResizableTextView: UITextViewDelegate {
  public func textViewDidBeginEditing(_ textView: UITextView) {
    bind(action: .focus)
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    bind(action: .endFocus(text: textView.text))
  }

  public func textViewDidChange(_ textView: UITextView) {
    bind(action: .bind(text: textView.text))
    checkOverflow(text: textView.text, maxLength: prop.maxLength)
    self.calculateCount(count: textView.text.count, maxLength: prop.maxLength)
    self.textView.calculate()
    self.sendActions(for: .valueChanged)
  }

  private func checkPlaceholderLabel(_ text: String) {
    if text.isEmpty {
      placeholderLabel.isHidden = false
    } else {
      placeholderLabel.isHidden = true
    }
  }
}
extension Reactive where Base: TFResizableTextView {
  public var text: ControlProperty<String> {
    return controlProperty(
      editingEvents: [.editingChanged, .valueChanged],
      getter: { $0.text ?? "" },
      setter: { base, value in
        if base.text != value {
          base.text = value
        }
      }
    )
  }
}
#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFResizableTextViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let component = TFResizableTextView()
      return component
    }
    .frame(width: 375, height: 120)
    .previewLayout(.sizeThatFits)
  }
}
#endif

