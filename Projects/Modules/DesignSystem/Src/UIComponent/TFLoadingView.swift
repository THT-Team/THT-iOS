//
//  TFLoadingView.swift
//  DSKit
//
//  Created by SeungMin on 2/2/25.
//

import UIKit
import Lottie

public final class TFLoadingView: TFBaseView {
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
//    stackView.spacing = 36
    stackView.alignment = .center
    return stackView
  }()
  
  private let loadingLottieView: LottieAnimationView  = {
    let view = LottieAnimationView(animation: AnimationAsset.mainLoading.animation)
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  private let loadingLabel: UILabel = {
    let label = UILabel()
    label.text = "주제 선택을 완료한\n 무디를 찾고있어요..."
    label.font = .thtSubTitle1R
    label.textColor = DSKitAsset.Color.neutral50.color
    label.numberOfLines = 0
    return label
  }()
  
  public override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.DimColor.loading.color
    
    self.addSubview(stackView)
    
    stackView.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview()
      $0.center.equalToSuperview()
    }
    
    stackView.addArrangedSubviews([
      loadingLottieView,
      loadingLabel
    ])
    
    loadingLottieView.snp.makeConstraints {
      $0.height.equalTo(100)
    }
  }
}
