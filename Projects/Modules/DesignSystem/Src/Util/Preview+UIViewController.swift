//
//  Preview+UIViewController.swift
//  DSKit
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit

public enum DeviceType {
  case iPhoneSE2
  case iPhone8
  case iPhone15
  case iPhone15Pro
  case iPhone15ProMax

  public func name() -> String {
    switch self {
    case .iPhoneSE2:
      return "iPhone SE"
    case .iPhone8:
      return "iPhone 8"
    case .iPhone15:
      return "iPhone 15"
    case .iPhone15Pro:
      return "iPhone 15 Pro"
    case .iPhone15ProMax:
      return "iPhone 15 Pro Max"
    }
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

public extension UIViewController {
  private struct PreView: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {
      return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
  }

  func showPreview(_ deviceType: DeviceType = .iPhone15Pro) -> some SwiftUI.View {
    PreView(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
  }
}

#endif
