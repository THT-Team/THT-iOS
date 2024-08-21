//
//  SinglePickerView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit

import Core

public class SinglePickerBottomSheetView: TFBaseView {

  private(set) lazy var pickerView = UIPickerView()
  private(set) lazy var btn = CTAButton(btnTitle: btnTitle, initialStatus: false)

  private let btnTitle: String

  public init(btnTitle: String) {
    self.btnTitle = btnTitle
    super.init(frame: .zero)
  }

  public override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral600.color
    self.clipsToBounds = true

    addSubviews(pickerView, btn)

    pickerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
    }

    btn.snp.makeConstraints {
      $0.top.equalTo(pickerView.snp.bottom).offset(10.adjustedH)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(38.adjusted)
      $0.height.equalTo(54.adjustedH)
      $0.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-24.adjustedH)
    }
  }
}

public extension UIPickerView {
  func drawSelectedSingleLine() {
    let selectedView = self.subviews[1]
    selectedView.backgroundColor = .clear

    let space = 10.0
    let fwidth = self.frame.width - (space * 2)
    let lineHeight = 2.f

    let fragmentWidth = fwidth / 3 - 3
    let fragmentY = selectedView.frame.height - lineHeight
    var dx = 0.0
    dx += fragmentWidth + 5
    let topLine = UIView(frame: CGRect(x: dx, y: 0, width: fragmentWidth, height: 2))
    let bottomLine = UIView(frame:CGRect(x: dx, y: fragmentY, width: fragmentWidth, height: 2))
    topLine.backgroundColor = DSKitAsset.Color.neutral500.color
    bottomLine.backgroundColor = DSKitAsset.Color.neutral500.color
    selectedView.addSubview(topLine)
    selectedView.addSubview(bottomLine)
  }

  func drawSelectedLine() {
    var selectedView = self.subviews[1]
        selectedView.backgroundColor = .clear

    let padding = 10.0
    let fwidth = self.frame.width - (padding * 2)
    let lineHeight = 2.f

    let space = 40.f

    let fragmentWidth = fwidth / 3 - space
    let fragmentY = selectedView.frame.height - lineHeight
    let d = space / 4
    var dx = padding

    for _ in 0..<3 {
      var topLine = UIView(frame: CGRect(x: dx, y: 0, width: fragmentWidth, height: lineHeight))
      var bottomLine = UIView(frame: CGRect(x: dx, y: fragmentY, width: fragmentWidth, height: lineHeight))
      dx += fragmentWidth + d
      topLine.backgroundColor = DSKitAsset.Color.neutral500.color
      bottomLine.backgroundColor = DSKitAsset.Color.neutral500.color
      selectedView.addSubview(topLine)
      selectedView.addSubview(bottomLine)
    }
  }

  func drawFixcedLabel(text: String) {
    let selectedView = self.subviews[1]
    let width = self.frame.width - (10 * 2)
    let fragmentWidth = width / 3 - 3
    let dx = (fragmentWidth + 5) * 2 + 10
    let label = UILabel(frame: CGRect(x: dx, y: 0, width: 100, height: 60))
    label.text = text
    label.font = .thtH4B
    label.textColor = DSKitAsset.Color.neutral400.color
    selectedView.addSubview(label)
  }


}
