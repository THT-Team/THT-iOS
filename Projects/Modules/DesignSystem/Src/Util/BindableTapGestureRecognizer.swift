//
//  BindableTapGestureRecognizer.swift
//  DSKit
//
//  Created by SeungMin on 2/16/25.
//

import Foundation
import UIKit

public final class BindableTapGestureRecognizer: UITapGestureRecognizer {
  private let action: () -> Void
  
  public init(action: @escaping () -> Void) {
    self.action = action
    super.init(target: nil, action: nil)
    self.addTarget(self, action: #selector(execute))
  }
  
  @objc private func execute() {
    action()
  }
}
