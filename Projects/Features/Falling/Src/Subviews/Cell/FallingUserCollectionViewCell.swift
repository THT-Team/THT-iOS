//
//  FallingUserCollectionViewCell.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import FallingInterface
import DSKit
import Domain

struct FallingUserCollectionViewCellObserver {
  var userCardScrollIndex: Observable<Int>
  var timerActiveTrigger: Observable<Bool>
}

final class FallingUserCollectionViewCell: TFBaseCollectionViewCell {
  private var dataSource: DataSource!
  
  lazy var profileCollectionView: TFBaseCollectionView = {
    let layout = UICollectionViewCompositionalLayout.horizontalListLayout()
    
    let collectionView = TFBaseCollectionView(
      frame: .zero,
      collectionViewLayout: layout
    )
    collectionView.backgroundColor = DSKitAsset.Color.DimColor.default.color
    collectionView.layer.cornerRadius = 20
    collectionView.isScrollEnabled = false
    return collectionView
  }()
  
  var photos: [UserProfilePhoto] = [] {
    didSet {
      userInfoBoxView.pageControl.currentPage = 0
      userInfoBoxView.pageControl.numberOfPages = oldValue.count
//      collectionView.reloadData()
    }
  }
  
  lazy var userInfoBoxView = UserInfoBoxView()
  
  lazy var cardTimeView = CardTimeView()
  
  lazy var pauseView: PauseView = {
    let pauseView = PauseView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: (UIWindow.keyWindow?.bounds.width ?? .zero) - 32,
        height: ((UIWindow.keyWindow?.bounds.width ?? .zero) - 32) * 1.64
      )
    )
    return pauseView
  }()
  
  override func makeUI() {
    self.layer.cornerRadius = 20
    
    self.contentView.addSubview(profileCollectionView)
    self.contentView.addSubview(cardTimeView)
    self.contentView.addSubview(userInfoBoxView)
    self.contentView.addSubview(pauseView)
    
    profileCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(profileCollectionView).inset(12)
      $0.height.equalTo(32)
    }
    
    self.userInfoBoxView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(12)
    }
    
    self.pauseView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.configureDataSource()
    
    self.profileCollectionView.showDimView()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  func bind<O>(
    _ viewModel: FallinguserCollectionViewCellModel,
    _ timerTrigger: Driver<Bool>,
    scrollToNextObserver: O
  ) where O: ObserverType, O.Element == Void {
    let input = FallinguserCollectionViewCellModel.Input(timerActiveTrigger: timerTrigger)
    
    let output = viewModel
      .transform(input: input)
    
    output.user
      .drive(self.rx.user)
      .disposed(by: disposeBag)
    
    output.timeState
      .drive(self.rx.timeState)
      .disposed(by: self.disposeBag)
    
    output.timeStart
      .drive(with: self, onNext: { owner, _ in
        owner.profileCollectionView.hiddenDimView()
      })
      .disposed(by: disposeBag)
    
    output.timeZero
      .drive(scrollToNextObserver)
      .disposed(by: disposeBag)
    
    output.isTimerActive
      .drive(pauseView.rx.isHidden)
      .disposed(by: disposeBag)
    
    userInfoBoxView.infoButton.rx.tap.asDriver()
      .scan(true) { lastValue, _ in
        return !lastValue
      }
      .drive(userInfoBoxView.tagCollectionView.rx.isHidden)
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

extension FallingUserCollectionViewCell {
  typealias Model = UserProfilePhoto
  typealias DataSource = UICollectionViewDiffableDataSource<FallingProfileSection, Model>
  typealias Snapshot = NSDiffableDataSourceSnapshot<FallingProfileSection, Model>
  
  func configureDataSource() {
    let profileCellRegistration = UICollectionView.CellRegistration<ProfileCollectionViewCell, Model> { cell, indexPath, item in
      cell.bind(imageURL: item.url)
    }
    
    self.dataSource = UICollectionViewDiffableDataSource(collectionView: profileCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
  }
  
  func setupDataSource(userProfilePhotos: [UserProfilePhoto]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.profile])
    snapshot.appendItems(userProfilePhotos)
    self.dataSource.apply(snapshot)
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
      
      base.profileCollectionView.transform = base.profileCollectionView.transform.rotated(by: timeState.rotateAngle)
      base.pauseView.transform = base.profileCollectionView.transform.rotated(by: timeState.rotateAngle)
    }
  }
  
  var user: Binder<FallingUser> {
    return Binder(self.base) { (base, user) in
      base.photos = user.userProfilePhotos
      base.setupDataSource(userProfilePhotos: user.userProfilePhotos)
      base.userInfoBoxView.bind(user)
    }
  }
}
