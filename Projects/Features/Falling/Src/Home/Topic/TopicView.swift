//
//  Untitled.swift
//  Falling
//
//  Created by SeungMin on 3/17/25.
//

import SwiftUI

import DSKit

struct TopicView: SwiftUI.View {
  var body: some SwiftUI.View {
    VStack(spacing: 0) {
      BubbleView(text: "무디와 같은 주제로 이야기할  수 있어요")
        .padding(.bottom, 6)
      
      
    }
  }
  
//  @ViewBuilder
//  private
}

#Preview {
  let view = TopicView()
  view
}
