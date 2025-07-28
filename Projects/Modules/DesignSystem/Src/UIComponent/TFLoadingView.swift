//
//  TFLoadingView.swift
//  DSKit
//
//  Created by SeungMin on 2/2/25.
//

import UIKit
import Lottie
import RxSwift

public final class TFLoadingView: TFBaseView {
  var disposeBag = DisposeBag()
  
  public let closeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.plain()
    config.image = DSKitAsset.Image.Icons.close.image.withTintColor(
      DSKitAsset.Color.neutral50.color,
      renderingMode: .alwaysOriginal
    )
    config.imagePlacement = .all
    config.baseBackgroundColor = DSKitAsset.Color.topicBackground.color
    button.configuration = config
    return button
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 36
    stackView.alignment = .center
    return stackView
  }()
  
//  let loadingLottieView: LottieAnimationView  = {
//    let view = LottieAnimationView(animation: AnimationAsset.mainLoading.animation)
//    view.contentMode = .scaleAspectFit
//    view.loopMode = .loop
//    return view
//  }()
  
  private let loadingImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.mainLoading.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let loadingLabel: UILabel = {
    let label = UILabel()
    label.text = "주제 선택을 완료한\n무디를 찾고있어요..."
    label.font = .thtSubTitle1R
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    label.numberOfLines = 0
    return label
  }()
  
  public init() {
    super.init(frame: .zero)
    bind()
  }
  
  public override func makeUI() {
    self.isHidden = true
    self.backgroundColor = DSKitAsset.Color.DimColor.loading.color
    
    self.addSubviews([stackView, closeButton])
    
    stackView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    
    stackView.addArrangedSubviews([
//      loadingLottieView,
      loadingImageView,
      loadingLabel
    ])
    
    loadingImageView.snp.makeConstraints {
      $0.width.height.equalTo(54)
    }
    
    closeButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(125)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(24)
    }
  }
    
  private func bind() {
    closeButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        self.isHidden = true
      }
      .disposed(by: disposeBag)
  }
}

extension Reactive where Base: TFLoadingView {
  public var isLoading: Binder<Bool> {
    return Binder(base) { view, isLaoading in
      view.isHidden = !isLaoading
      
//      if isLaoading {
//        view.loadingLottieView.play()
//      } else {
//        view.loadingLottieView.stop()
//      }
    }
  }
}
