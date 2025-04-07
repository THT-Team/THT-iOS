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
        choiceTopicView()
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
  private func headerView() -> some SwiftUI.View {
    VStack(spacing: 8) {
      Text("NEW TOPIC")
        .font(weight: 500, size: 16, lineSpacingPercent: 140)
        .foregroundStyle(Color.neutral400)
      
      Text("오늘 나는 너랑...")
        .font(weight: 600, size: 17, lineSpacingPercent: 130)
        .foregroundStyle(Color.neutral50)
    }
  }
  
  @ViewBuilder
  private func choiceTopicView() -> some SwiftUI.View {
    // TODO: 데이터 반영해야 함
    
    Group {
//      VStack(spacing: 12) {
        //      ForEach(0..<4) { index in
        //              fourMultipleChoiceTopicView(index: index)
        //      }
//      }
      
      //    HStack(spacing: 12) {
      //      ForEach(0..<2) { index in
      //        twoMultipleChoiceTopicView(
      //          emoji: DSKitAsset.Image.Icons.mind.swiftUIImage,
      //          title: "여행",
      //          subtitle: "도심에서\n호텔 숙박"
      //        )
      //      }
      //    }
      //    .overlay(
      //      Text("VS")
      //        .font(weight: 700, size: 24, lineSpacingPercent: 130)
      //        .foregroundStyle(Color.primary500)
      //        .padding(.vertical, 10.5)
      //        .padding(.horizontal, 12.5)
      //        .background(Color.neutral700)
      //        .clipShape(RoundedRectangle(cornerRadius: 56))
      //    )
      
      oneChiceView()
    }
    .padding(.top, 24)
    .padding(.bottom, 32)
  }
  
  @ViewBuilder
  private func oneChiceView() -> some SwiftUI.View {
    VStack(spacing: 16) {
      DSKitAsset.Image.Icons.topicCard.swiftUIImage
        .resizable()
        .scaledToFit()
      
      Text(
        """
        오늘은 토요일!
        모두와 대화에 Falling!
        """
      )
      .font(weight: 600, size: 17, lineSpacingPercent: 130)
      .foregroundStyle(Color.neutral50)
      .multilineTextAlignment(.center)
    }
    .padding(.horizontal, 31)
    .padding(.vertical, 28)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .padding(0.5)
    .overlay {
      RoundedRectangle(cornerRadius: 24)
        .inset(by: 1)
        .stroke(Color.primary500, lineWidth: 1)
    }
  }
  
  @ViewBuilder
  private func twoMultipleChoiceTopicView(
    emoji: Image,
    title: String,
    subtitle: String
  ) -> some SwiftUI.View {
    Button {
      
    } label: {
      VStack(spacing: 0) {
        emoji
          .resizable()
          .scaledToFit()
          .frame(width: 72, height: 72)
          .padding(.bottom, 16)
        
        Text(title)
          .font(weight: 400, size: 12, lineSpacingPercent: 140)
          .foregroundStyle(Color.neutral300)
          .multilineTextAlignment(.center)
        
        Text(subtitle)
          .font(weight: 600, size: 17, lineSpacingPercent: 130)
          .foregroundStyle(Color.neutral50)
          .multilineTextAlignment(.center)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 94.5)
      .clipShape(RoundedRectangle(cornerRadius: 24))
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .inset(by: 0.5)
        // TODO: 선택 Stroke 색상 변경
          .stroke(Color.neutral600, lineWidth: 1)
      )
    }
  }
  
  @ViewBuilder
  private func fourMultipleChoiceTopicView(index: Int) -> some SwiftUI.View {
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
          .inset(by: 0.5)
        // TODO: 선택 Stroke 색상 변경
          .stroke(Color.neutral600, lineWidth: 1)
        //          .stroke(Color.primary500)
      )
      .padding(.bottom, 32)
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some SwiftUI.View {
    VStack(spacing: 19) {
      Button("시작하기") {
        
      }
      .buttonStyle(.submit)
      
      HStack(spacing: 8) {
        Text("다음 주제어까지 ")
          .font(weight: 400, size: 12, lineSpacingPercent: 140)
          .foregroundStyle(Color.neutral300)
        
        Text("14:19:00")
          .font(weight: 500, size: 14, lineSpacingPercent: 140)
          .foregroundStyle(Color.neutral50)
      }
    }
  }
}

#Preview {
  let view = TopicView()
  view
}
