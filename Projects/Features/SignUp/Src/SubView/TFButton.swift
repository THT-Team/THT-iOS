//
//  File.swift
//  SignUp
//
//  Created by kangho lee on 7/27/24.
//

import UIKit
import DSKit

public class TFButton: CTAButton {
  public override init(btnTitle: String, initialStatus: Bool) {
    super.init(btnTitle: btnTitle, initialStatus: initialStatus)
    titleLabel?.font = .thtH2B
    setTitle(btnTitle, for: .normal)
    layer.cornerRadius = 12
    updateColors(status: initialStatus)
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
