
//  Preview+UIView.swift
//  Core
//
//  Created by Kanghos on 2024/01/10.

import UIKit

#if canImport(SwiftUI) && DEBUG
import SwiftUI
public struct UIViewPreview<View: UIView>: UIViewRepresentable {
  public let view: View

  public init(_ builder: @escaping () -> View) {
    view = builder()
  }

  public func makeUIView(context: Context) -> some UIView {
    return view
  }

  public func updateUIView(_ uiView: UIViewType, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}


#endif
