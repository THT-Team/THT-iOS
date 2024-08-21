//
//  TFPinField.swift
//  DSKit
//
//  Created by kangho lee on 7/26/24.
//

import UIKit

import RxSwift
import RxCocoa

@objc public protocol TFPinFieldDelegate : AnyObject {
  @objc optional func pinField(_ field: TFPinField, didChangeTo string: String, isValid: Bool)
  func pinField(_ field: TFPinField, didFinishWith code: String)
}

public extension TFPinFieldDelegate {
  
}

public struct TFPinFieldProperties {
  public weak var delegate : TFPinFieldDelegate? = nil
  public var numberOfCharacters: Int = 6 {
    didSet {
      precondition(numberOfCharacters >= 0, "🚫 Number of character must be >= 0, with 0 meaning dynamic")
    }
  }
  public var validCharacters: String = "0123456789" {
    didSet {
      precondition(validCharacters.count > 0, "🚫 There must be at least 1 valid character")
      precondition(!validCharacters.contains(token), "🚫 Valid characters can't contain token \"\(token)\"")
    }
  }
  public var token: Character = "•" {
    didSet {
      precondition(!validCharacters.contains(token), "🚫 token can't be one of the valid characters \"\(token)\"")
      precondition(!token.isWhitespace, "🚫 token can't be a whitespace. Please use a token with a clear color to achieve the same effect")
    }
  }
  public var isUppercased: Bool = false
  public var keyboardType: UIKeyboardType = .numberPad
}

public struct TFPinFieldAppearance {

  public init() {}

  public var font : UIFont?
  public var tokenColor : UIColor = .black
  public var tokenFocusColor : UIColor = .gray
  public var textColor : UIColor = .black
  public var kerning : CGFloat = 20.0
  public var backColor : UIColor = UIColor.clear
  public var backBorderColor : UIColor = UIColor.clear
  public var backBorderWidth : CGFloat = 1
  public var backCornerRadius : CGFloat = 4
  public var backOffset : CGFloat = 4
  public var backFocusColor : UIColor = .clear
  public var backBorderFocusColor : UIColor = .black
  public var backActiveColor : UIColor = .clear
  public var backBorderActiveColor : UIColor = .black
  public var backRounded : Bool = false
}

public class TFPinField : UITextField {
  public var didFinish: ((String) -> Void)?

  // Mark: - Public vars
  private(set) var properties = TFPinFieldProperties() {
    didSet {
      self.reload()
    }
  }
  private(set) var appearance = TFPinFieldAppearance() {
    didSet {
      self.reloadAppearance()
    }
  }

  public func updateProperties(block : ((inout TFPinFieldProperties) -> ())) {
    var properties = self.properties
    block(&properties)
    self.properties = properties
  }

  public func updateAppearance(block : ((inout TFPinFieldAppearance) -> ())) {
    var appearance = self.appearance
    block(&appearance)
    self.appearance = appearance
  }

  // Mark: - Overriden vars
  public override var text : String? {
    get { return invisibleText }
    set {
      self.invisibleField.text = newValue
    }
  }

  public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    return action == #selector(paste(_:))
  }

  // Mark: - Private vars

  // Uses an invisible UITextField to handle text
  private lazy var invisibleField: UITextField = {
    let textField = UITextField()
    textField.textAlignment = .center
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.spellCheckingType = .no
    textField.textContentType = .oneTimeCode
    textField.addAction(.init {[weak self] _ in
      self?.reloadAppearance()
    }, for: .allEditingEvents)
    textField.isHidden = true

    // Debugging ---------------
    // Change alpha for easy debug
    let alpha: CGFloat = 0.9
    textField.backgroundColor = UIColor.white.withAlphaComponent(alpha * 0.8)
    textField.tintColor = UIColor.black.withAlphaComponent(alpha)
    textField.textColor = UIColor.black.withAlphaComponent(alpha)
    // --------------------------
    return textField
  }()
  private var invisibleText : String {
    get {
      return invisibleField.text ?? ""
    }
    set {
      self.reloadAppearance()
    }
  }

  private var attributes: [NSAttributedString.Key : Any] = [:]
  private var backViews: [UIView] = [UIView]()
  private var lastEntry: String = ""
  private var currentFocusRange : NSRange?
  private var previousCode : String?

  // Mark: - UIKeyInput
  public override func insertText(_ text: String) {
    self.invisibleField.insertText(text)
  }

  public override func deleteBackward() {
    self.invisibleField.deleteBackward()
  }

  public override var hasText: Bool {
    return self.invisibleField.hasText
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    register()
  }

  public func register() {
    if #available(iOS 17.0, *) {
      registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (traitEnvironment: Self, previousTraitCollection: UITraitCollection) in
        traitEnvironment.reload()
      }
    } else {

    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Mark: - Lifecycle

  public override var keyboardAppearance: UIKeyboardAppearance {
    get { return self.invisibleField.keyboardAppearance }
    set { self.invisibleField.keyboardAppearance = newValue}
  }

  public override var keyboardType: UIKeyboardType {
    get { return self.invisibleField.keyboardType }
    set { self.invisibleField.keyboardType = newValue}
  }

  public override func reloadInputViews() {
    invisibleField.reloadInputViews()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    self.bringSubviewToFront(self.invisibleField)
    self.invisibleField.frame = self.bounds

    // back views
    let nsText: NSString = (0..<self.properties.numberOfCharacters).reduce("") { result, _ in result + "0" } as NSString

    let textFrame = nsText.boundingRect(with: self.bounds.size,
                                        options: .usesLineFragmentOrigin,
                                        attributes: self.attributes,
                                        context: nil)

    let actualWidth = textFrame.width
    + (self.appearance.kerning * self.properties.numberOfCharacters.f)
    let digitWidth = actualWidth / self.properties.numberOfCharacters.f

    let offset = (self.bounds.width - actualWidth) / 2

    self.backViews.enumerated().forEach { index, v in
      let x = index.f * digitWidth + offset
      var vFrame = CGRect(x: x,
                          y: self.bounds.height,
                          width: digitWidth,
                          height: 2)
//      vFrame.origin.x += self.appearance.backOffset / 2
//      vFrame.size.width -= self.appearance.backOffset
      v.frame = vFrame
    }
  }

  // Mark: - Public functions

  @discardableResult override public func becomeFirstResponder() -> Bool {
    return self.invisibleField.becomeFirstResponder()
  }

  @discardableResult override public func
  resignFirstResponder() -> Bool {
    return self.invisibleField.resignFirstResponder()
  }

  // Mark: - Private function

  private func styleSlot(_ slot: UIView) {

  }

  private func reload() {

    // Only setup if view showing
    guard self.superview != nil else {
      return
    }

    self.endEditing(true)

    self.inputAccessoryView = nil

    // Prepare `invisibleField`

    self.invisibleField.keyboardType = self.properties.keyboardType

    self.addSubview(self.invisibleField)

    // Prepare visible field
    self.tintColor = .clear // Hide cursor
    self.invisibleField.tintColor = .clear // Hide cursor
    self.contentVerticalAlignment = .center

    // Set back views
    self.backViews.forEach { $0.removeFromSuperview() }
    self.backViews.removeAll(keepingCapacity: false)
    (0..<self.properties.numberOfCharacters).forEach { v in
      let v = UIView()
      backViews.append(v)
      self.addSubview(v)
      self.sendSubviewToBack(v)
    }

    // Delay fixes kerning offset issue
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      self.reloadAppearance()
    }
  }

  // Updates textfield content
  public func reloadAppearance() {
    // Styling backviews
    self.backViews.forEach { v in
      v.alpha = 1.0
      v.backgroundColor = self.appearance.backColor
      v.layer.borderColor = self.appearance.backBorderColor.cgColor
      v.layer.borderWidth = self.appearance.backBorderWidth
      v.layer.cornerRadius = self.appearance.backCornerRadius
    }

    self.sanitizeText()

    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center

    let font =  self.appearance.font!
    self.attributes = [ .paragraphStyle : paragraph,
                        .font : font,
                        .kern : self.appearance.kerning]

    // Display
    let attString = NSMutableAttributedString(string: "")

    (0..<self.properties.numberOfCharacters).forEach { i in
      var string = ""
      var isToken = false
      if i < invisibleText.count {
        let index = invisibleText.index(string.startIndex, offsetBy: i)
        string = String(invisibleText[index])
      } else {
        isToken = true
        string = String(self.properties.token)
      }

      // Color for active / inactive
      let backIndex = i
      if !self.backViews.isEmpty && backIndex < self.backViews.count {
        let backView = self.backViews[backIndex]
        if isToken {
          attributes[.foregroundColor] = self.appearance.tokenColor
          backView.backgroundColor = self.appearance.backColor
          backView.layer.borderColor = self.appearance.backBorderColor.cgColor
        } else {
          attributes[.foregroundColor] = self.appearance.textColor
          backView.backgroundColor = self.appearance.backActiveColor
          backView.layer.borderColor = self.appearance.backBorderActiveColor.cgColor
        }
      }

      // Fix kerning-centering
      let indexForKernFix = self.properties.numberOfCharacters - 1
      if i == indexForKernFix {
        attributes[.kern] = 0.0
      }

      attString.append(NSAttributedString(string: string, attributes: attributes))
    }
    self.updateCursorPosition()

    self.attributedText = attString

    if invisibleText == self.previousCode {
      return
    }
    self.previousCode = invisibleText
    self.checkCodeValidity()
  }

  private func sanitizeText() {
    var text = self.invisibleField.text ?? ""

    if properties.isUppercased {
      text = text.uppercased()
    }

    if text != lastEntry {
      let isValid = text.reduce(true) { result, char -> Bool in
        return result && self.properties.validCharacters.contains(char)
      }
      if text.count <= self.properties.numberOfCharacters {
        self.properties.delegate?.pinField?(self, didChangeTo: text, isValid: isValid)
        self.didFinish?(text)
      }

      lastEntry = text
    }

    text = String(text.lazy.filter(self.properties.validCharacters.contains))
    text = String(text.prefix(self.properties.numberOfCharacters))
    self.invisibleField.text = text
  }

  // Always position cursor on last valid character
  private func updateCursorPosition() {
    self.currentFocusRange = nil
    let offset = min(self.invisibleText.count, self.properties.numberOfCharacters)
    // Only works with a small delay
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      if let position = self.invisibleField.position(from: self.invisibleField.beginningOfDocument, offset: offset) {

        let textRange = self.textRange(from: position, to: position)
        self.invisibleField.selectedTextRange = textRange

        // Compute the currently focused element
        if   let attString = self.attributedText?.mutableCopy() as? NSMutableAttributedString,
             var range = self.invisibleField.selectedRange,
             range.location >= -1 && range.location < self.properties.numberOfCharacters {

          // Compute range of focused text
          range.length = 1

          // Make sure it's a token that is focused
          let string = attString.string
          let startIndex = string.index(string.startIndex, offsetBy: range.location)
          let endIndex = string.index(startIndex, offsetBy: 1)
          let sub = string[startIndex..<endIndex]
          if sub == String(self.properties.token) {

            // Token focus color
            var atts = attString.attributes(at: range.location, effectiveRange: nil)
            atts[.foregroundColor] = self.appearance.tokenFocusColor
            attString.setAttributes(atts, range: range)

            // Avoid long fade from tick()
            UIView.transition(with: self, duration: 0.1, options: [.transitionCrossDissolve, .allowUserInteraction], animations: {
              self.attributedText = attString
            }, completion: nil)

            self.currentFocusRange = range

            // Backview focus color
            var backIndex = offset
            backIndex = min(backIndex, self.properties.numberOfCharacters-1)
            backIndex = max(backIndex, 0)
            if !self.backViews.isEmpty && backIndex < self.backViews.count {
              let backView = self.backViews[backIndex]
              backView.backgroundColor = self.appearance.backFocusColor
              backView.layer.borderColor = self.appearance.backBorderFocusColor.cgColor
            }
          }
        }
      }
    }
  }

  private func checkCodeValidity() {

    if self.invisibleText.count == self.properties.numberOfCharacters {
//      self.didFinish?(invisibleText)
      if let pinDelegate = self.properties.delegate {
        let result = self.invisibleText
        pinDelegate.pinField(self, didFinishWith: result)
      } else {
        print("⚠️ : No delegate set for KAPinField. Set it via yourPinField.properties.delegate.")
      }
    }
  }
  
  public func onError() {
    DispatchQueue.main.async {
      self.backViews.forEach {
        $0.backgroundColor = DSKitAsset.Color.error.color
        $0.setNeedsDisplay()
      }
    }
  }
}

private extension UITextInput {
  var selectedRange: NSRange? {
    guard let range = selectedTextRange else { return nil }
    let location = offset(from: beginningOfDocument, to: range.start)
    let length = offset(from: range.start, to: range.end)
    return NSRange(location: location, length: length)
  }
}

//extension Reactive where Base: TFPinField {
//  
//  var delegate: DelegateProxy<TFPinField, TFPinFieldDelegate> {
//    RxTFPinFieldDelegateProxy.proxy(for: base)
//  }
//
//  public var pin: ControlEvent<String> {
//    let source = delegate.methodInvoked(#selector(TFPinFieldDelegate.pinField(_:didFinishWith:)))
//      .debug("")
//      .map { a in
//        return a[1] as? String ?? ""
//      }
//
//    return ControlEvent(events: source)
//  }
//}
//
//open class RxTFPinFieldDelegateProxy: DelegateProxy<TFPinField, TFPinFieldDelegate>, DelegateProxyType, TFPinFieldDelegate {
//  public func pinField(_ field: TFPinField, didFinishWith code: String) {
//    _forwardToDelegate?.pinField(field, didFinishWith: code)
//  }
//  
//  public static func currentDelegate(for object: TFPinField) -> (any TFPinFieldDelegate)? {
//    object.properties.delegate
//  }
//  
//  public static func setCurrentDelegate(_ delegate: (any TFPinFieldDelegate)?, to object: TFPinField) {
//    object.updateProperties { properties in
//      properties.delegate = delegate
//    }
//  }
//  
//  public static func registerKnownImplementations() {
//    self.register { RxTFPinFieldDelegateProxy(pinField: $0)}
//  }
//  
//  
//  public weak private(set) var pinField: TFPinField?
//  
//  public init(pinField: TFPinField) {
//    self.pinField = pinField
//    super.init(parentObject: pinField, delegateProxy: RxTFPinFieldDelegateProxy.self)
//  }
//}
