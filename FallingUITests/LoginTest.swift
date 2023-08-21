//
//  FallingUITests.swift
//  FallingUITests
//
//  Created by SeungMin on 2023/08/21.
//

import XCTest
@testable import Falling

final class FallingUITests: XCTestCase {
  
  var app: XCUIApplication!
  var phoneBtn: XCUIElement!
  var kakoBtn: XCUIElement!
  var naverBtn: XCUIElement!
  var googleBtn: XCUIElement!
  var phoneNumberTextField: XCUIElement!
  var verifyBtn: XCUIElement!
  
  override func setUpWithError() throws {
    app = XCUIApplication()
    phoneBtn = app.buttons[AccessibilityIdentifier.phoneBtn]
    kakoBtn = app.buttons[AccessibilityIdentifier.kakoBtn]
    naverBtn = app.buttons[AccessibilityIdentifier.naverBtn]
    googleBtn = app.buttons[AccessibilityIdentifier.googleBtn]
    phoneNumberTextField = app.textFields[AccessibilityIdentifier.phoneNumberTextField]
    verifyBtn = app.buttons[AccessibilityIdentifier.verifyBtn]
    
    Keychain.shared.clear()
    continueAfterFailure = false
    
    app.launch()
  }
  
  override func tearDownWithError() throws {
    app = nil
    phoneBtn = nil
    kakoBtn = nil
    naverBtn = nil
    googleBtn = nil
  }
  
  func testPhoneAuthenticationSuccess() throws {
    let input = "01011112222"
    
    phoneBtn.tap()
    
    phoneNumberTextField.tap()

    input.forEach { app.keys[String($0)].tap() }
    
    verifyBtn.tap()
    
    Thread.sleep(forTimeInterval: 1)
  }
}
