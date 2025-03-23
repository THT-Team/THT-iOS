//
//  PickerBottomSheetView.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import Core

public class PickerBottomSheetView: TFBaseView {

  private(set) lazy var pickerView: UIPickerView = {
    let pickerView = UIPickerView()

    return pickerView
  }()

  private(set) lazy var buttonHStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    return stackView
  }()

  private(set) lazy var initializeButton = CTAButton(btnTitle: "확인", initialStatus: true)

  public override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral600.color

    addSubviews(pickerView, buttonHStackView)

    [initializeButton].forEach {
      buttonHStackView.addArrangedSubview($0)
    }

    pickerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
    }

    buttonHStackView.snp.makeConstraints {
      $0.top.equalTo(pickerView.snp.bottom).offset(10)
      $0.height.equalTo(50)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(30)
      $0.bottom.equalTo(self.safeAreaLayoutGuide)
    }

    self.clipsToBounds = true
  }

  func drawSelectedLine() {
    var selectedView = pickerView.subviews[1]
        selectedView.backgroundColor = .clear

    let space = 10.0
    let fwidth = pickerView.frame.width - (space * 2)

    let fragmentWidth = fwidth / 3 - 3
    let fragmentY = selectedView.frame.height - 3
    var dx = 0.0
    for _ in 0..<3 {
      var topLine = UIView(frame: CGRect(x: dx, y: 0, width: fragmentWidth, height: 3))
      var bottomLine = UIView(frame: CGRect(x: dx, y: fragmentY, width: fragmentWidth, height: 3))
      dx += fragmentWidth + 5
      topLine.backgroundColor = DSKitAsset.Color.neutral500.color
      bottomLine.backgroundColor = DSKitAsset.Color.neutral500.color
      selectedView.addSubview(topLine)
      selectedView.addSubview(bottomLine)
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PickerBottomSheetViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      return PickerBottomSheetView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
