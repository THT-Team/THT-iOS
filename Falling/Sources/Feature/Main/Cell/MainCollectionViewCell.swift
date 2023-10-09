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
  
  lazy var userImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .add
    return imageView
  }()
  
  lazy var userContentView: UIView = {
    let view = UIView()
    view.backgroundColor = FallingAsset.Color.clear.color
    return view
  }()

  lazy var profileCarouselView = ProfileCarouselView()
  
  lazy var progressContainerView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 15
    view.backgroundColor = FallingAsset.Color.dimColor.color.withAlphaComponent(0.5)
    return view
  }()
  
  lazy var timerView = CardTimerView()
  
  lazy var progressView = CardProgressView()
  
  override func layoutSubviews() {
    self.backgroundColor = .systemGray
  }
  
  override func makeUI() {
    // TODO: cornerRadius 동적으로 설정해야 할 것.
    self.layer.cornerRadius = 15
    
    self.addSubview(userImageView)
    self.addSubview(userContentView)

    
    self.userContentView.addSubviews([profileCarouselView, progressContainerView])
    
    self.progressContainerView.addSubviews([
      timerView,
      progressView
    ])
    
    self.userImageView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    self.userContentView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
    
    self.progressContainerView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide).inset(12)
      $0.leading.trailing.equalToSuperview().inset(12)
      $0.height.equalTo(32)
    }
    
    self.timerView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(9)
      $0.centerY.equalToSuperview()
      $0.width.equalTo(22)
      $0.height.equalTo(22)
    }
    
    self.progressView.snp.makeConstraints {
      $0.leading.equalTo(timerView.snp.trailing).offset(9)
      $0.trailing.equalToSuperview().inset(12)
      $0.centerY.equalToSuperview()
      $0.height.equalTo(6)
    }

    self.profileCarouselView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
    profileCarouselView.tagCollectionView.isHidden = true
  }
  
  func setup(item: UserDomain) {
    viewModel = MainCollectionViewItemViewModel(userDomain: item)
  }
  
  func bindViewModel() {
    profileCarouselView.infoButton.rx.tap.asDriver()
      .scan(true) { lastValue, _ in
        return !lastValue
      }.drive(profileCarouselView.tagCollectionView.rx.isHidden)
      .disposed(by: disposeBag)

    let output = viewModel.transform(input: MainCollectionViewItemViewModel.Input())
    
    output.timeState
      .drive(self.rx.timeState)
      .disposed(by: self.disposeBag)
    
    output.isTimeOver
      .do { value in
        if value { self.delegate?.scrollToNext() }
      }.drive()
      .disposed(by: self.disposeBag)

    output.user
      .drive(onNext: { [weak self] user in
        self?.profileCarouselView.configure(user)
      })
    .disposed(by: disposeBag)
  }
  
  func dotPosition(progress: Double, rect: CGRect) -> CGPoint {
    var progress = progress
    // progress가 -0.05미만 혹은 1이상은 점(dot)을 0초에 위치시키기 위함
    let strokeRange: Range<Double> = -0.05..<0.95
    if !(strokeRange ~= progress) { progress = 0.95 }
    let radius = CGFloat(rect.height / 2 - timerView.strokeLayer.lineWidth / 2)
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
      base.timerView.trackLayer.strokeColor = timeState.fillColor.color.cgColor
      base.timerView.strokeLayer.strokeColor = timeState.color.color.cgColor
      base.timerView.dotLayer.strokeColor = timeState.color.color.cgColor
      base.timerView.dotLayer.fillColor = timeState.color.color.cgColor
      base.timerView.timerLabel.textColor = timeState.color.color
      base.progressView.progressBarColor = timeState.color.color
      
      base.timerView.dotLayer.isHidden = timeState.isDotHidden
      
      base.timerView.timerLabel.text = timeState.getText
      
      base.progressView.progress = CGFloat(timeState.getProgress)
      
      // TimerView Animation은 소수점 둘째 자리까지 표시해야 오차가 발생하지 않음
      let strokeEnd = round(CGFloat(timeState.getProgress) * 100) / 100
      base.timerView.dotLayer.position = base.dotPosition(progress: strokeEnd, rect: base.timerView.bounds)
      
      base.timerView.strokeLayer.strokeEnd = strokeEnd
    }
  }
}
