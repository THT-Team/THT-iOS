//
//  TopicBottomSheetView.swift
//  Falling
//
//  Created by SeungMin on 7/31/25.
//

import SwiftUI

import DSKit

struct TopicBottomSheetView: SwiftUI.View {
  let viewModel: TopicBottomSheetViewModel
  
  var body: some SwiftUI.View {
    VStack(spacing: 0) {
      timeView()
      contentView()
    }
    .padding(.horizontal, 22)
    .padding(.top, 22)
    .padding(.bottom, 44)
    .background(Color.neutral700)
  }
  
  @ViewBuilder
  private func timeView() -> some SwiftUI.View {
    HStack(spacing: 8) {
      Spacer(minLength: 0)
      
      DSKitAsset.Image.Icons.stopwatch.swiftUIImage
        .resizable()
        .scaledToFit()
        .frame(width: 26, height: 26)
      
      Text("주제어 변경까지")
        .font(weight: 500, size: 15, lineSpacingPercent: 140)
        .foregroundStyle(Color.neutral300)
      
      Text(viewModel.timerViewModel.formattedTime)
        .font(weight: 500, size: 15, lineSpacingPercent: 140)
        .foregroundStyle(Color.primary500)
      
      Text("남음")
        .font(weight: 500, size: 15, lineSpacingPercent: 140)
        .foregroundStyle(Color.neutral300)
      
      Spacer(minLength: 0)
    }
    .padding(.vertical, 6)
    .background(Color.neutral600)
    .clipShape(RoundedRectangle(cornerRadius: 24))
    .padding(.bottom, 42)
  }
  
  @ViewBuilder
  private func contentView() -> some SwiftUI.View {
    VStack(spacing: 0) {
      DSKitAsset.Image.Icons.yetDailyTopic.swiftUIImage
        .resizable()
        .scaledToFit()
        .padding(.bottom, 48)
      
      Text("아직 주제어 변경 시간이 좀 남았네요!")
        .font(weight: 600, size: 19, lineSpacingPercent: 130)
        .foregroundStyle(Color.neutral50)
        .padding(.bottom, 6)
      
      Text("아직 주제어 변경 시간이 좀 남았네요!")
        .font(weight: 400, size: 14, lineSpacingPercent: 140)
        .foregroundStyle(Color.neutral300)
    }
  }
}
