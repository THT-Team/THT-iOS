//
//  TFCheckButton.swift
//  SignUp
//
//  Created by Kanghos on 5/30/24.
//

import UIKit

import RxSwift

import DSKit

final class TFCheckButton: UIButton {

  init(btnTitle: String, initialStatus: Bool) {
    super.init(frame: .zero)
    makeUI(title: btnTitle)
    updateColors(status: initialStatus)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI(title: String) {
    setTitleColor(DSKitAsset.Color.neutral50.color, for: .normal)
    self.setTitle(title, for: .normal)
    self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -200, bottom: 0, right: 0)
    self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)

    self.layer.cornerRadius = 16
    self.layer.masksToBounds = true
  }

  /// update CTA button color by status
  func updateColors(status: Bool) {
    if status {
      backgroundColor = DSKitAsset.Color.payment.color
      setImage(DSKitAsset.Image.Component.checkCirSelect.image, for: .normal)
    } else {
      backgroundColor = DSKitAsset.Color.neutral600.color
      setImage(DSKitAsset.Image.Component.checkCir.image, for: .normal)
    }
  }
}

extension Reactive where Base: TFCheckButton {
  var buttonStatus: Binder<Bool> {
    return Binder(base.self) { btn, status in
      btn.updateColors(status: status)
    }
  }
}
