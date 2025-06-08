//
//  Untitled.swift
//  Falling
//
//  Created by SeungMin on 3/17/25.
//

import SwiftUI

import DSKit

struct TopicView: SwiftUI.View {
  let viewModel: TopicViewModel
  
  var body: some SwiftUI.View {
    VStack(spacing: 0) {
      
      if !viewModel.hasChosenDailyTopic {
        BubbleView(
          text: "무디와 같은 주제로 이야기할 수 있어요",
          horizontalPadding: 16,
          verticalPadding: 6,
          cornerRadius: 16
        )
        .padding(.bottom, 6)
      }
      
      ScrollView(showsIndicators: false) {
        LazyVStack(spacing: 0) {
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
    }
    .onChange(of: viewModel.timerViewModel.isFinished, { oldValue, newValue in
      if oldValue != newValue && newValue {
        viewModel.didFinishDailyTopic()
      }
    })
  }
  
  @ViewBuilder
  private func headerView() -> some SwiftUI.View {
    VStack(spacing: 8) {
      Text("NEW TOPIC")
        .font(weight: 500, size: 16, lineSpacingPercent: 140)
        .foregroundStyle(Color.neutral400)
      
      if let introduction = viewModel.dailyTopicKeyword?.introduction {
        Text(introduction)
          .font(weight: 600, size: 17, lineSpacingPercent: 130)
          .foregroundStyle(Color.neutral50)
      }
    }
  }
  
  @ViewBuilder
  private func choiceTopicView() -> some SwiftUI.View {
    if let dailyTopicKeyword = viewModel.dailyTopicKeyword {
      Group {
        switch dailyTopicKeyword.type {
        case .oneChoice:
          oneChiceView(
            topicDailyKeyword: dailyTopicKeyword
          )
        case .twoChoice:
          twoMultipleChoiceTopicView(
            topicDailyKeyword: dailyTopicKeyword
          )
        case .fourChoice:
          fourMultipleChoiceTopicView(
            topicDayilKeyword: dailyTopicKeyword
          )
        }
      }
      .padding(.top, 24)
      .padding(.bottom, 32)
    }
  }
  
  @ViewBuilder
  private func oneChiceView(topicDailyKeyword: TopicDailyKeyword) -> some SwiftUI.View {
    if let topic = topicDailyKeyword.fallingTopicList.first {
      Button {
        viewModel.didTapTopicKeyword(topic)
      } label: {
        VStack(spacing: 16) {
          if let url = URL(string: topic.keywordImageURL) {
            KFImage(url)
              .loadDiskFileSynchronously()
              .cacheMemoryOnly()
              .resizable()
              .scaledToFit()
          }
          
          Text(topic.keyword)
            .font(weight: 600, size: 17, lineSpacingPercent: 130)
            .foregroundStyle(Color.neutral50)
            .multilineTextAlignment(.center)
            .lineLimit(2)
        }
        .padding(.horizontal, 31)
        .padding(.vertical, 28)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(0.5)
        .overlay {
          RoundedRectangle(cornerRadius: 24)
            .inset(by: 1)
            .stroke(topic == viewModel.selectedTopic ? Color.primary500 : Color.neutral600, lineWidth: 1)
        }
      }
    }
  }
  
  @ViewBuilder
  private func twoMultipleChoiceTopicView(topicDailyKeyword: TopicDailyKeyword) -> some SwiftUI.View {
    HStack(spacing: 12) {
      ForEach(topicDailyKeyword.fallingTopicList, id: \.index) { dailyKeyword in
        twoMultipleChoiceTopicCell(topic: dailyKeyword)
      }
    }
    .overlay(
      Text("VS")
        .font(weight: 700, size: 24, lineSpacingPercent: 130)
        .foregroundStyle(Color.primary500)
        .padding(.vertical, 10.5)
        .padding(.horizontal, 12.5)
        .background(Color.neutral700)
        .clipShape(RoundedRectangle(cornerRadius: 56))
    )
  }
  
  @ViewBuilder
  private func twoMultipleChoiceTopicCell(topic: DailyKeyword) -> some SwiftUI.View {
    Button {
      viewModel.didTapTopicKeyword(topic)
    } label: {
      VStack(spacing: 0) {
        if let url = URL(string: topic.keywordImageURL) {
          KFImage(url)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .resizable()
            .scaledToFit()
            .frame(width: 72, height: 72)
            .padding(.bottom, 16)
        }
        
        Text(topic.keyword)
          .font(weight: 400, size: 12, lineSpacingPercent: 140)
          .foregroundStyle(Color.neutral300)
          .multilineTextAlignment(.center)
          .lineLimit(1)
        
        Text(topic.talkIssue)
          .font(weight: 600, size: 17, lineSpacingPercent: 130)
          .foregroundStyle(Color.neutral50)
          .multilineTextAlignment(.center)
          .lineLimit(2)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 94.5)
      .clipShape(RoundedRectangle(cornerRadius: 24))
      .overlay(
        RoundedRectangle(cornerRadius: 24)
          .inset(by: 0.5)
          .stroke(viewModel.selectedTopic == topic ? Color.primary500 : Color.neutral600, lineWidth: 1)
      )
    }
  }
  
  @ViewBuilder
  private func fourMultipleChoiceTopicView(topicDayilKeyword: TopicDailyKeyword) -> some SwiftUI.View {
    VStack(spacing: 12) {
      ForEach(topicDayilKeyword.fallingTopicList, id: \.index) { dailyKeyword in
        fourMultipleChoiceTopicCell(topic: dailyKeyword)
      }
    }
  }
  
  @ViewBuilder
  private func fourMultipleChoiceTopicCell(topic: DailyKeyword) -> some SwiftUI.View {
    Button {
      viewModel.didTapTopicKeyword(topic)
    } label: {
      VStack(spacing: 6) {
        HStack(spacing: 2) {
          if let url = URL(string: topic.keywordImageURL) {
            KFImage(url)
              .loadDiskFileSynchronously()
              .cacheMemoryOnly()
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
          }
          
          Text(topic.keyword)
            .font(weight: 400, size: 12, lineSpacingPercent: 140)
            .foregroundStyle(Color.neutral300)
        }
        
        HStack(spacing: 0) {
          Spacer(minLength: 0)
          Text(topic.talkIssue)
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
          .stroke(topic == viewModel.selectedTopic ? Color.primary500 : Color.neutral600, lineWidth: 1)
      )
    }
  }
  
  @ViewBuilder
  private func bottomButtonView() -> some SwiftUI.View {
    VStack(spacing: 19) {
      Button("시작하기") {
        viewModel.didTapStartButton()
      }
      .buttonStyle(.submit)
      .disabled(viewModel.selectedTopic == nil)
      
      HStack(spacing: 8) {
        Text("다음 주제어까지")
          .font(weight: 400, size: 12, lineSpacingPercent: 140)
          .foregroundStyle(Color.neutral300)
        
        Text(viewModel.timerViewModel.formattedTime)
          .font(weight: 500, size: 14, lineSpacingPercent: 140)
          .foregroundStyle(Color.neutral50)
      }
    }
  }
}

#Preview {
  let viewModel = TopicViewModel()
  let view = TopicView(viewModel: viewModel)
  view
}
