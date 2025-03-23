//
//  TFCounterTextField.swift
//  SignUp
//
//  Created by Kanghos on 7/20/24.
//

import UIKit
import RxCocoa

public class TFCounterTextField: UIControl, TFFieldProtocol {
  public enum DescriptionLine {
    case single
    case multi
  }

  private enum Color {
    static let focus =  DSKitAsset.Color.primary500.color
    static let normal = DSKitAsset.Color.neutral300.color
    static let error = DSKitAsset.Color.error.color
    static let secondary = DSKitAsset.Color.neutral400.color
  }

  public enum Action {
    case bind(text: String)
    case error(inputError: InputError)
  }

  public struct ViewState: Equatable {
    var fieldState: TFBaseField.ViewState
  }

  public struct Prop {
    let description: String
    let maxLength: Int
    let placeholder: String
  }

  public var viewState: ViewState {
    willSet {
      if self.viewState != newValue {
        self.render(newValue)
      }
    }
  }
  private let prop: Prop

  public var text: String? {
    set {
      if self.text != newValue {
        self.send(action: .bind(text: newValue ?? ""))
        self.textField.sendActions(for: .editingChanged)
      }
    } get {
      self.viewState.fieldState.text
    }
  }

  public var placeholder: String? = nil {
    didSet {
      self.textField.placeholder = placeholder
    }
  }

  public lazy var textField = TFBaseField( placeholder: prop.placeholder)

  private lazy var countLabel = UILabel().then {
    $0.text = "(0/\(prop.maxLength)"
    $0.font = .thtP2M
    $0.textColor = Color.secondary
    $0.textAlignment = .left
    $0.numberOfLines = 2
  }

  public private(set) lazy var descriptionView: some UIView = {
    switch descriptionLine {
    case .single:
      TFOneLineDescriptionView(description: prop.description)
    case .multi:
      TFMultiLineDescriptionView(description: prop.description)
    }
  }()
  //  = TFMultiLineDescriptionView(description: prop.description)

  private let descriptionLine: DescriptionLine
  public init(
    description: String,
    maxLength: Int,
    placeholder: String,
    descriptionLine: DescriptionLine = .single
  ) {
    self.descriptionLine = descriptionLine
    self.prop = Prop(description: description, maxLength: maxLength, placeholder: placeholder)
    self.viewState = .init(fieldState: .init())
    super.init(frame: .zero)
    makeUI()
    bindAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func makeUI() {
    addSubviews(
      textField,
      descriptionView,
      countLabel
    )

    textField.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
    }

    descriptionView.snp.makeConstraints {
      $0.top.equalTo(textField.snp.bottom)
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
    }

    countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    countLabel.snp.makeConstraints {
      $0.leading.equalTo(descriptionView.snp.trailing)
      $0.height.equalTo(20)
      $0.trailing.bottom.equalToSuperview()
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
      newState.fieldState.dividerState = .focus
      newState.fieldState.errorDescription = ""
    case let .error(inputError):
      newState.fieldState.dividerState = .error
      switch inputError {
      case .validate(let text):
        newState.fieldState.errorDescription = text
      case .overflow:
        newState.fieldState.errorDescription = "\(prop.maxLength)자 이상 입력할 수 없습니다."
        let text = newState.fieldState.text
        let endIndex = text.index(text.startIndex, offsetBy: prop.maxLength)
        let range = text[text.startIndex..<endIndex]
        newState.fieldState.text = String(range)
      }
    }

    self.viewState = newState
  }

  public func bindAction() {
    self.textField.addAction(UIAction  { [weak self] _ in
      guard let self else { return }
      send(action: .bind(text: self.textField.text ?? ""))
      checkOverflow(text: self.textField.text ?? "", maxLength: self.prop.maxLength)
    }, for: .editingChanged)
  }

  private func checkOverflow(text: String, maxLength: Int) {
    if text.count > maxLength {
      self.send(action: .error(inputError: .overflow))
    }
  }

  public func render(_ state: ViewState) {

    self.textField.render(state.fieldState)
    countLabel.attributedText = makeCountText(count: state.fieldState.text.count, maxLength: prop.maxLength)
  }

  private func makeCountText(count: Int, maxLength: Int) -> NSAttributedString {
    let target = "\(count)"
    let fullText = "(\(target)/\(maxLength))"
    return fullText.asFont(target: target, font: .thtCaption1B)
  }
}

public extension Reactive where Base: TFCounterTextField {
  var text: ControlProperty<String> {
    return base.textField.rx.text.orEmpty
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct TFCounterFieldPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      let component = TFCounterTextField(description: "ㅁㄴㅇㄹㄴㅁㅇ", maxLength: 10, placeholder: "ㅁㄴㅇㄹ")
      return component
    }
    .frame(width: .infinity, height: 100)
    .previewLayout(.sizeThatFits)
  }
}
#endif

