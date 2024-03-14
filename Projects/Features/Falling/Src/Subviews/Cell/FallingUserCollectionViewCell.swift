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
  
  private var indexPath: IndexPath? {
    guard let collectionView = self.superview as? UICollectionView,
          let indexPath = collectionView.indexPath(for: self) else {
      TFLogger.ui.error("indexPath 얻기 실패")
      return nil
    }
    return indexPath
  }
  
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
  
  lazy var userInfoCollectionView: UserInfoCollectionView = {
    let collectionView = UserInfoCollectionView()
    collectionView.layer.cornerRadius = 20
    collectionView.clipsToBounds = true
    collectionView.collectionView.backgroundColor = DSKitAsset.Color.DimColor.default.color
    collectionView.isHidden = true
    return collectionView
  }()
  
  override func makeUI() {
    self.layer.cornerRadius = 20
    
    self.contentView.addSubview(profileCollectionView)
    self.contentView.addSubview(cardTimeView)
    self.contentView.addSubview(userInfoBoxView)
    self.contentView.addSubview(userInfoCollectionView)
    self.contentView.addSubview(pauseView)
    
    profileCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(profileCollectionView).inset(12)
      $0.height.equalTo(32)
    }
    
    self.userInfoBoxView.snp.makeConstraints {
      $0.height.equalTo(145)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(12)
    }
    
    userInfoCollectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(300)
      $0.bottom.equalTo(userInfoBoxView.snp.top).offset(-8)
    }
    
    self.pauseView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.profileCollectionView.showDimView()
    
    self.setDataSource()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  func bind<O>(
    _ viewModel: FallinguserCollectionViewCellModel,
    timerActiveTrigger: Driver<Bool>,
    timeOverSubject: PublishSubject<Void>,
    profileDoubleTapTriggerObserver: PublishSubject<Void>,
    fallingCellButtonAction: O
  ) where O: ObserverType, O.Element == FallingCellButtonAction {
    let input = FallinguserCollectionViewCellModel.Input(
      timerActiveTrigger: timerActiveTrigger
    )
    
    let output = viewModel
      .transform(input: input)
    
    output.user
      .drive(self.rx.user)
      .disposed(by: disposeBag)
    
    output.timeState
      .drive(self.rx.timeState)
      .disposed(by: self.disposeBag)
    
    output.timeStart
      .drive(with: self) { owner, _ in
        owner.profileCollectionView.hiddenDimView()
      }
      .disposed(by: disposeBag)
    
    output.timeZero
      .drive(timeOverSubject)
      .disposed(by: disposeBag)
    
    output.isTimerActive
      .drive(pauseView.rx.isHidden)
      .disposed(by: disposeBag)
    
    let profileDoubleTapTrigger = self.profileCollectionView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .mapToVoid()
      .asDriverOnErrorJustEmpty()
    
    let pauseViewDoubleTapTrigger = self.pauseView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .mapToVoid()
      .asDriverOnErrorJustEmpty()
    
    Driver.merge(profileDoubleTapTrigger, pauseViewDoubleTapTrigger)
      .map { _ in }
      .drive(profileDoubleTapTriggerObserver)
      .disposed(by: disposeBag)
    
    profileCollectionView.rx.didEndDisplayingCell.asDriver()
      .debug()
      .drive(with: self) { owner, indexPath in
        self.userInfoBoxView.pageControl.currentPage
      }
      .disposed(by: disposeBag)
    
    userInfoBoxView.infoButton.rx.tap.asDriver()
      .scan(true, accumulator: { value, _ in
        return !value
      })
      .drive(userInfoCollectionView.rx.isHidden)
      .disposed(by: disposeBag)
    
    userInfoBoxView.refuseButton.rx.tapGesture()
      .when(.recognized)
      .compactMap { [weak self] _ in self?.indexPath }
      .map { FallingCellButtonAction.refuse($0) }
      .bind(to: fallingCellButtonAction)
      .disposed(by: disposeBag)
    
    userInfoBoxView.likeButton.rx.tapGesture()
      .when(.recognized)
      .compactMap { [weak self] _ in self?.indexPath }
      .map { FallingCellButtonAction.like($0) }
      .bind(to: fallingCellButtonAction)
      .disposed(by: disposeBag)
  }
  
  func bind(userProfilePhotos: [UserProfilePhoto]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.profile])
    snapshot.appendItems(userProfilePhotos)
    self.dataSource.apply(snapshot)
    
    userInfoBoxView.pageControl.numberOfPages = userProfilePhotos.count
  }
  
  func dotPosition(progress: CGFloat, rect: CGRect) -> CGPoint {
    let progress = round(progress * 100) / 100 // 오차를 줄이기 위함
    let radius = CGFloat(rect.height / 2 - cardTimeView.timerView.strokeLayer.lineWidth / 2)
    
    var angle = 2 * CGFloat.pi * progress - CGFloat.pi / 2 + CGFloat.pi / 6 // 두 원의 중점과 원점이 이루는 각도를 30도로 가정
    if angle <= -CGFloat.pi / 2 || CGFloat.pi * 1.5 <= angle  {
      angle = -CGFloat.pi / 2 // 정점 각도
    }
    
    let dotX = radius * cos(angle)
    let dotY = radius * sin(angle)
    
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
  
  func setDataSource() {
    let profileCellRegistration = UICollectionView.CellRegistration<ProfileCollectionViewCell, Model> { cell, indexPath, item in
      cell.bind(imageURL: item.url)
    }
    
    self.dataSource = UICollectionViewDiffableDataSource(collectionView: profileCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
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
      
      base.cardTimeView.progressView.progress = timeState.getProgress
      
      let strokeEnd = timeState.getProgress
      base.cardTimeView.timerView.dotLayer.position = base.dotPosition(progress: strokeEnd, rect: base.cardTimeView.timerView.bounds)
      
      base.cardTimeView.timerView.strokeLayer.strokeEnd = strokeEnd
      
      base.profileCollectionView.transform = base.profileCollectionView.transform.rotated(by: timeState.rotateAngle)
    }
  }
  
  var user: Binder<FallingUser> {
    return Binder(self.base) { (base, user) in
      base.bind(userProfilePhotos: user.userProfilePhotos)
      base.userInfoBoxView.bind(user)
      base.userInfoCollectionView.bind(user)
    }
  }
}
