//
//  UserCollectionViewCell.swift
//  Falling
//
//  Created by SeungMin on 2023/10/02.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

@objc protocol TimeOverDelegate: AnyObject {
  @objc func scrollToNext()
}

final class MainCollectionViewCell: TFBaseCollectionViewCell {
  
  var viewModel: MainCollectionViewItemViewModel!
  weak var delegate: TimeOverDelegate?
  
  lazy var profileCarouselView = ProfileCarouselView()
  
  lazy var cardTimeView = CardTimeView()
  
  override func layoutSubviews() {
    self.backgroundColor = .systemGray
  }
  
  override func makeUI() {
    self.contentView.addSubviews([profileCarouselView, cardTimeView])
    
    self.profileCarouselView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.cardTimeView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    profileCarouselView.tagCollectionView.isHidden = true
  }
  
  func bind(model: UserDomain) {
    viewModel = MainCollectionViewItemViewModel(userDomain: model)
    profileCarouselView.bind(viewModel.userDomain)
  }

  func bindViewModel(action: Driver<Bool>) {
    profileCarouselView.infoButton.rx.tap.asDriver()
      .scan(true) { lastValue, _ in
        return !lastValue
      }
      .drive(profileCarouselView.tagCollectionView.rx.isHidden)
      .disposed(by: disposeBag)
    
    let input = MainCollectionViewItemViewModel.Input(timerActiveTrigger: action)
//    let input = MainCollectionViewItemViewModel.Input()
    
    let output = viewModel
      .transform(input: input)
    
    output.timeState
      .drive(self.rx.timeState)
      .disposed(by: self.disposeBag)
    
    output.isTimeOver
      .do { value in
        if value { self.delegate?.scrollToNext() }
      }.drive()
      .disposed(by: self.disposeBag)
    
//    output.timerActive.map { value in
//      if value { }
//    }
    
//    output.user
//      .drive(onNext: { [weak self] user in
//        self?.profileCarouselView.bind(user)
//      })
//      .disposed(by: disposeBag)
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

extension Reactive where Base: MainCollectionViewCell {
  var timeState: Binder<MainCollectionViewItemViewModel.TimeState> {
    return Binder(self.base) { (base, timeState) in
      base.cardTimeView.timerView.trackLayer.strokeColor = timeState.fillColor.color.cgColor
      base.cardTimeView.timerView.strokeLayer.strokeColor = timeState.color.color.cgColor
      base.cardTimeView.timerView.dotLayer.strokeColor = timeState.color.color.cgColor
      base.cardTimeView.timerView.dotLayer.fillColor = timeState.color.color.cgColor
      base.cardTimeView.timerView.timerLabel.textColor = timeState.color.color
      base.cardTimeView.progressView.progressBarColor = timeState.color.color
      
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
