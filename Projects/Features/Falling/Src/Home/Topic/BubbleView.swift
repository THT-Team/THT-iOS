//
//  BubbleView.swift
//  Falling
//
//  Created by SeungMin on 3/17/25.
//

import SwiftUI

import DSKit

struct BubbleView: SwiftUI.View {
  var text: String
  var horizontalPadding: CGFloat
  var verticalPadding: CGFloat
  var cornerRadius: CGFloat
  var tailWidth: CGFloat = 14
  var tailHeight: CGFloat = 8
  var tailRadius: CGFloat = 2
  
  var body: some SwiftUI.View {
    Text(text)
      .font(weight: 500, size: 12, lineSpacingPercent: 140)
      .foregroundStyle(Color.neutral900)
      .padding(.horizontal, horizontalPadding)
      .padding(.vertical, verticalPadding)
      .background(
        BubbleShape(
          cornerRadius: cornerRadius,
          tailWidth: tailWidth,
          tailHeight: tailHeight,
          tailRadius: tailRadius
        )
        .fill(Color.neutral50)
      )
      .padding(.bottom, tailHeight + tailRadius)
  }
}

struct BubbleShape: Shape {
  var cornerRadius: CGFloat
  var tailWidth: CGFloat
  var tailHeight: CGFloat
  var tailRadius: CGFloat
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    let width = rect.width
    let height = rect.height
    let tailStartX = (width / 2) - (tailWidth / 2)
    let tailEndX = (width / 2) + (tailWidth / 2)
    
    // 시작점 (왼쪽 위)
    path.move(to: CGPoint(x: cornerRadius, y: 0))
    
    // 오른쪽 위
    path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
    path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: -90),
                endAngle: Angle(degrees: 0),
                clockwise: false)
    
    // 오른쪽 아래
    path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
    path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false)
    
    // 꼭지 (Tail)
    path.addLine(to: CGPoint(x: tailEndX, y: height))
    path.addArc(center: CGPoint(x: width / 2, y: height + tailHeight),
                radius: tailRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 180),
                clockwise: false)
    path.addLine(to: CGPoint(x: tailStartX, y: height))
    
    // 왼쪽 아래
    path.addLine(to: CGPoint(x: cornerRadius, y: height))
    path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false)
    
    // 왼쪽 위로 닫기
    path.addLine(to: CGPoint(x: 0, y: cornerRadius))
    path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                radius: cornerRadius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: -90),
                clockwise: false)
    
    return path
  }
}

#Preview {
  let view = BubbleView(
    text: "말풍선 뷰",
    horizontalPadding: 15.5,
    verticalPadding: 6,
    cornerRadius: 24
  )
  view
}
