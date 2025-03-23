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
      
      VStack(spacing: 0) {
        headerView()
        topicListView()
        bottomButtonView()
      }
      .frame(maxWidth: .infinity)
      .padding(.top, 32)
      .padding(.horizontal, 16)
      .padding(.bottom, 17)
      .background(
        LinearGradient(
          colors: [
            Color(hex: "#1D1D1D"),
            Color(hex: "#161616"),
            Color(hex: "#1D1D1D"),
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: 20))
      .overlay(
        RoundedRectangle(cornerRadius: 20)
          .inset(by: 1)
          .stroke(
            LinearGradient(
              colors: [
                Color(hex: "#414141").opacity(0.3),
                Color(hex: "#1A1A1A").opacity(0.9)
              ],
              startPoint: .top,
              endPoint: .bottom
            ),
            lineWidth: 1
          )
      )
    }
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  private func topicListView() -> some SwiftUI.View {
    VStack(spacing: 12) {
      ForEach(0..<4) { index in
        topicCell()
      }
    }
  }
  
  @ViewBuilder
  private func headerView() -> some SwiftUI.View {
    VStack(spacing: 8) {
      Text("NEW TOPIC")
        .font(weight: 500, size: 16, lineSpacingPercent: 140)
        .foregroundStyle(Color.neutral400)
      
      Text("오늘 나는 너랑...")
        .font(weight: 600, size: 17, lineSpacingPercent: 130)
        .foregroundStyle(Color.neutral50)
    }
    .padding(.bottom, 24)
  }
  
  @ViewBuilder
  private func topicCell() -> some SwiftUI.View {
    Button {
    } label: {
      VStack(spacing: 6) {
        HStack(spacing: 2) {
          DSKitAsset.Image.Icons.mind.swiftUIImage
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
          
          Text("휴식")
            .font(weight: 400, size: 12, lineSpacingPercent: 140)
            .foregroundStyle(Color.neutral300)
        }
        
        HStack(spacing: 0) {
          Spacer(minLength: 0)
          Text("좋았던 여행에 대해 이야기하고싶어")
            .font(weight: 400, size: 14, lineSpacingPercent: 140)
            .foregroundStyle(Color.neutral50)
          Spacer(minLength: 0)
        }
      }
      .padding(15)
      .background(Color.neutral700)
      .clipShape(RoundedRectangle(cornerRadius: 56))
      .overlay(
        RoundedRectangle(cornerRadius: 56)
          .inset(by: 1)
          .stroke(Color.neutral600, lineWidth: 1)
      )
      .padding(.bottom, 32)
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some SwiftUI.View {
    Button("시작하기") {
      
    }
    .buttonStyle(.submit)
  }
}

#Preview {
  let view = TopicView()
  view
}
