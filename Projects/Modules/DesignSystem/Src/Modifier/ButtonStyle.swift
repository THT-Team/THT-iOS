//
//  ButtonStyle.swift
//  DSKit
//
//  Created by SeungMin on 3/23/25.
//

import SwiftUI

public struct SubmitButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) var isEnabled
  
  public func makeBody(configuration: ButtonStyle.Configuration) -> some SwiftUI.View {
    
    configuration.label
      .font(weight: 700, size: 17, lineSpacingPercent: 130)
      .foregroundStyle(Color.neutral900)
      .frame(maxWidth: .infinity)
      .frame(height: 56)
      .background {
        RoundedRectangle(cornerRadius: 16)
          .fill(isEnabled ? Color(hex: "#F9CC2E") : Color(hex: "#F9CC2E1A"))
      }
      .opacity(configuration.isPressed ? 0.3 : 1)
  }
}

extension ButtonStyle where Self == SubmitButtonStyle {
  public static var submit: SubmitButtonStyle {
    SubmitButtonStyle()
  }
}

#Preview {
  Button("버튼") {
    
  }
  .buttonStyle(.submit)
  .padding(.horizontal, 16)
}
