////
////  TFTextView.swift
////  SignUp
////
////  Created by Kanghos on 2024/04/24.
////
//
//import UIKit
//
//
//public class TFTextView: UIControl {
//  private let maxHeight: CGFloat = 120
//  private let minHeight: CGFloat = 40
//  private var textViewHeightConstraint: NSLayoutConstraint?
//
//  public enum State {
//    case text(text: String?)
//    case error(text: String)
//  }
//
//  private enum DivderState {
//    case focus
//    case nonFocus
//    case error
//  }
//
//  private enum Color {
//    static let focus =  DSKitAsset.Color.primary500.color
//    static let nonFocus = DSKitAsset.Color.neutral300.color
//    static let error = DSKitAsset.Color.error.color
//    static let secondary = DSKitAsset.Color.neutral400.color
//  }
//
//  public var text: String? {
//    set {
//      if self.text != newValue {
//        self.render(state: .text(text: newValue))
//      }
//    } get {
//      return self.textField.text
//    }
//  }
//
//  /// set Total Count
//  private var totalCount: Int
//
//  lazy var textField = UITextView().then {
//    $0.textColor = Color.focus
//    $0.font = .thtSubTitle1R
//    $0.isScrollEnabled = false
//    $0.isEditable = true
//    $0.keyboardType = .asciiCapable
//  }
//
//  lazy var clearBtn: UIButton = UIButton.makeClearBtn()
//
//  lazy var divider: UIView = UIView().then {
//    $0.backgroundColor = DSKitAsset.Color.neutral300.color
//  }
//
//  private let descriptionView: TFFieldDescriptionView
//
//  lazy var errorDescriptionLabel = UILabel().then {
//    $0.font = .thtCaption1M
//    $0.textColor = DSKitAsset.Color.error.color
//    $0.textAlignment = .left
//    $0.numberOfLines = 3
//  }
//
//  lazy var countLabel = UILabel().then {
//    $0.text = "(0/12)"
//    $0.font = .thtCaption1R
//    $0.textColor = DSKitAsset.Color.neutral400.color
//    $0.textAlignment = .left
//    $0.numberOfLines = 2
//  }
//
//  init(description: String = "", totalCount: Int = 200, placeholder: String? = nil) {
//    self.totalCount = totalCount
//    self.descriptionView = .init(description: description)
//    super.init(frame: .zero)
//    makeUI()
//  }
//
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  func makeUI() {
//    addSubviews(
//      textField, clearBtn,
//      divider,
//      errorDescriptionLabel,
//      descriptionView, countLabel
//    )
//
//    textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
//    textField.snp.makeConstraints {
//      $0.top.leading.equalToSuperview()
//      $0.trailing.equalTo(clearBtn.snp.leading)
//    }
//    self.textViewHeightConstraint = textField.heightAnchor.constraint(equalToConstant: minHeight)
//    self.textViewHeightConstraint?.isActive = true
//
//    clearBtn.snp.makeConstraints {
//      $0.leading.equalTo(textField.snp.trailing)
//      $0.bottom.equalTo(textField)
//      $0.trailing.equalToSuperview()
//      $0.size.equalTo(24)
//    }
//
//    divider.snp.makeConstraints {
//      $0.leading.trailing.equalToSuperview()
//      $0.top.equalTo(textField.snp.bottom).offset(2)
//      $0.height.equalTo(2)
//    }
//
//    errorDescriptionLabel.snp.makeConstraints {
//      $0.leading.trailing.equalToSuperview()
//      $0.top.equalTo(divider.snp.bottom)
//      $0.height.equalTo(20).priority(.low)
//    }
//
//    descriptionView.snp.makeConstraints {
//      $0.leading.equalTo(textField)
//      $0.top.equalTo(errorDescriptionLabel.snp.bottom)
//      $0.bottom.equalToSuperview()
//    }
//
//    countLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//    countLabel.snp.makeConstraints {
//      $0.trailing.equalToSuperview()
//      $0.top.equalTo(descriptionView)
//    }
//
//    calculateCount(count: 0)
//    bindAction()
//  }
//
//  func bindAction() {
//    clearBtn.addAction(UIAction(handler: { [weak self] _ in
//      self?.render(state: .text(text: nil))
//    }), for: .touchUpInside)
//
//    textField.delegate = self
//  }
//
//  func render(state: State) {
//    switch state {
//    case let .text(text):
//      self.errorDescriptionLabel.isHidden = true
//      self.textField.text = text
//      self.updateDividerColor(.focus)
//      self.sendActions(for: .valueChanged)
//
//    case let .error(text):
//      self.errorDescriptionLabel.isHidden = false
//      self.errorDescriptionLabel.text = text
//      self.updateDividerColor(.error)
//    }
//  }
//
//  private func calculateCount(count: Int) {
//    let fullText = "(\(count)/\(totalCount))"
//    let target = "\(count)"
//    self.countLabel.text = fullText
//    self.countLabel.asFont(targetString: target, font: .thtCaption1B)
//
//    if count > totalCount {
//      self.render(state: .error(text: "\(totalCount)이상 입력할 수 없습니다."))
//    }
//  }
//
//  private func updateDividerColor(_ state: DivderState) {
//    switch state {
//    case .error:
//      self.divider.backgroundColor = Color.error
//    case .focus:
//      self.divider.backgroundColor = Color.focus
//    case .nonFocus:
//      if self.divider.backgroundColor != Color.error {
//        self.divider.backgroundColor = Color.nonFocus
//      }
//    }
//  }
//}
//
//extension TFTextView: UITextViewDelegate {
//  public func textViewDidBeginEditing(_ textView: UITextView) {
//    updateDividerColor(.focus)
//  }
//
//  public func textViewDidEndEditing(_ textView: UITextView) {
//    updateDividerColor(.nonFocus)
//  }
//
//  public func textViewDidChange(_ textView: UITextView) {
//    self.calculateCount(count: textView.text.count)
//    self.sendActions(for: .valueChanged)
//  }
//}
//  extension Reactive where Base: TFTextView {
//    public var text: ControlProperty<String?> {
//
//      return controlProperty(
//        editingEvents: [.editingChanged, .valueChanged],
//        getter: { $0.text },
//        setter: { base, value in
//          if base.text != value {
//            base.text = value
//          }
//        }
//      )
//    }
//  }
//
//#if canImport(SwiftUI) && DEBUG
//  import SwiftUI
//
//  struct TFTextViewPreview: PreviewProvider {
//
//    static var previews: some SwiftUI.View {
//      UIViewPreview {
//        let component = TFTextView()
//        //      component.render(state: .error(error: .validate(text: "중복된 닉네임입니다.")))
//        return component
//      }
//      .frame(width: 375, height: 120)
//      .previewLayout(.sizeThatFits)
//    }
//  }
//#endif
