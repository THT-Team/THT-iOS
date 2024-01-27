//
//  FallingUserCollectionViewCell.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import Core
import DSKit
import FallingInterface

struct FallingUserCollectionViewCellObserver {
  var userCardScrollIndex: Observable<Int>
  var timerActiveTrigger: Observable<Bool>
}

final class FallingUserCollectionViewCell: TFBaseCollectionViewCell {
  
  lazy var profileCarouselView = ProfileCarouselView()
  
  lazy var cardTimeView = CardTimeView()
  
  override func makeUI() {
    self.layer.cornerRadius = 20
    
    self.contentView.addSubview(profileCarouselView)
    self.profileCarouselView.addSubview(cardTimeView)
    
    self.profileCarouselView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  func bind<O>(
    _ viewModel: FallinguserCollectionViewCellModel,
    _ timerTrigger: Driver<Bool>,
    scrollToNextObserver: O) where O: ObserverType, O.Element == Void
   {
    let input = FallinguserCollectionViewCellModel.Input(timerActiveTrigger: timerTrigger)

    let output = viewModel
      .transform(input: input)

    output.timeState
      .drive(self.rx.timeState)
      .disposed(by: self.disposeBag)

    output.isDimViewHidden
      .drive(with: self, onNext: { owner, isHidden in
        if isHidden {
          owner.profileCarouselView.hiddenDimView()
        } else {
          owner.profileCarouselView.showDimView()
        }
      })
      .disposed(by: disposeBag)

    output.timeZero
      .drive(scrollToNextObserver)
      .disposed(by: disposeBag)

    output.user
      .drive(with: self, onNext: { owner, user in
        owner.profileCarouselView.bind(user)
      })
      .disposed(by: disposeBag)

    profileCarouselView.infoButton.rx.tap.asDriver()
      .scan(true) { lastValue, _ in
        return !lastValue
      }
      .drive(profileCarouselView.tagCollectionView.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  func dotPosition(progress: Double, rect: CGRect) -> CGPoint {
    var progress = progress
    // progress가 -0.05미만 혹은 1이상은 점(dot)을 0초에 위치시키기 위함
    let strokeRange: Range<Double> = -0.05..<0.95
    if !(strokeRange ~= progress) { progress = 0.95 }
    let radius = CGFloat(rect.height / 2 - cardTimeView.timerView.strokeLayer.lineWidth / 2)
    let angle = 2 * CGFloat.pi * CGFloat(progress) - CGFloat.pi / 2
    let dotX = radius * cos(angle + 0.35)
    let dotY = radius * sin(angle + 0.35)
    
    let point = CGPoint(x: dotX, y: dotY)
    
    return CGPoint(
      x: rect.midX + point.x,
      y: rect.midY + point.y
    )
  }
}

extension Reactive where Base: FallingUserCollectionViewCell {
  var timeState: Binder<TimeState> {
    return Binder(self.base) { (base, timeState) in
      base.cardTimeView.timerView.trackLayer.strokeColor = timeState.fillColor.color.cgColor
      base.cardTimeView.timerView.strokeLayer.strokeColor = timeState.timerTintColor.color.cgColor
      base.cardTimeView.timerView.dotLayer.strokeColor = timeState.timerTintColor.color.cgColor
      base.cardTimeView.timerView.dotLayer.fillColor = timeState.timerTintColor.color.cgColor
      base.cardTimeView.timerView.timerLabel.textColor = timeState.timerTintColor.color
      base.cardTimeView.progressView.progressBarColor = timeState.progressBarColor.color
      
      base.cardTimeView.timerView.dotLayer.isHidden = timeState.isDotHidden
      
      base.cardTimeView.timerView.timerLabel.text = timeState.getText
      
      base.cardTimeView.progressView.progress = CGFloat(timeState.getProgress)
      
      // TimerView Animation은 소수점 둘째 자리까지 표시해야 오차가 발생하지 않음
      let strokeEnd = round(CGFloat(timeState.getProgress) * 100) / 100
      base.cardTimeView.timerView.dotLayer.position = base.dotPosition(progress: strokeEnd, rect: base.cardTimeView.timerView.bounds)
      
      base.cardTimeView.timerView.strokeLayer.strokeEnd = strokeEnd
    }
  }
}
