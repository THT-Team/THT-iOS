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
  
  lazy var lottieView: LottieAnimationView = {
    let lottieAnimationView = LottieAnimationView()
    lottieAnimationView.isHidden = true
    lottieAnimationView.contentMode = .scaleAspectFit
    return lottieAnimationView
  }()
  
  lazy var userInfoView: UserInfoView = {
    let view = UserInfoView()
    view.layer.cornerRadius = 20
    view.clipsToBounds = true
    view.collectionView.backgroundColor = DSKitAsset.Color.DimColor.default.color
    view.isHidden = true
    return view
  }()
  
  override func makeUI() {
    self.layer.cornerRadius = 20
    
    self.contentView.addSubviews([profileCollectionView, cardTimeView, userInfoBoxView, userInfoBoxView, userInfoView, lottieView, pauseView])
    
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
    
    userInfoView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.equalTo(300)
      $0.bottom.equalTo(userInfoBoxView.snp.top).offset(-8)
    }
    
    self.pauseView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.lottieView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.width.height.equalTo(188) // TODO: 사이즈 수정 예정
    }
    
    self.profileCollectionView.showDimView()
    
    self.setDataSource()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }
  
  func bind<O>(
    _ viewModel: FallingUserCollectionViewCellModel,
    timerActiveTrigger: Driver<Bool>,
    timeOverSubject: PublishSubject<AnimationAction>,
    profileDoubleTapTriggerObserver: PublishSubject<Void>,
    fallingCellButtonAction: O,
    reportButtonTapTriggerObserver: PublishSubject<Void>,
    deleteCellTrigger: Driver<Void>
  ) where O: ObserverType, O.Element == FallingCellButtonAction {
    let infoButtonTapTrigger = userInfoBoxView.infoButton.rx.tap.asDriver()
    
    let rejectButtonTapTrigger = userInfoBoxView.rejectButton.rx.tap.asDriver()
    
    let likeButtonTapTrigger = userInfoBoxView.likeButton.rx.tap.asDriver()
    
    let reportButtonTapTrigger = userInfoView.reportButton.rx.tap.asDriver()
    
    let showUserInfoTrigger = Driver.merge(infoButtonTapTrigger, reportButtonTapTrigger).scan(true) { value, _ in
      return !value
    }
    
    let input = FallingUserCollectionViewCellModel.Input(
      timerActiveTrigger: timerActiveTrigger,
      showUserInfoTrigger: showUserInfoTrigger,
      rejectButtonTapTrigger: rejectButtonTapTrigger,
      likeButtonTapTrigger: likeButtonTapTrigger,
      reportButtonTapTrigger: reportButtonTapTrigger,
      deleteCellTrigger: deleteCellTrigger
    )
    
    let output = viewModel
      .transform(input: input)
    
    output.user
      .drive(self.rx.user)
      .disposed(by: disposeBag)
    
    output.timeState
      .drive(self.rx.timeState)
      .disposed(by: self.disposeBag)
    
    output.timeZero
      .drive(timeOverSubject)
      .disposed(by: disposeBag)
    
    output.timerActiveAction
      .drive(self.rx.timerActiveAction)
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
    
    output.showUserInfoAction
      .drive(userInfoView.rx.isHidden)
      .disposed(by: disposeBag)
      
    output.rejectButtonAction
      .compactMap { [weak self] _ in self?.indexPath }
      .map { FallingCellButtonAction.reject($0) }
      .drive(with: self) { owner, action in
        fallingCellButtonAction.onNext(action)
        owner.lottieView.snp.updateConstraints { $0.width.height.equalTo(188) }
        owner.lottieView.animation = AnimationAsset.unlike.animation
        owner.lottieView.isHidden = false
        owner.lottieView.play()
      }
      .disposed(by: disposeBag)
    
    output.likeButtonAction
      .compactMap { [weak self] _ in self?.indexPath }
      .map { FallingCellButtonAction.like($0) }
      .drive(with: self) { owner, action in
        fallingCellButtonAction.onNext(action)
        owner.lottieView.snp.updateConstraints { $0.width.height.equalTo(200) }
        owner.lottieView.animation = AnimationAsset.likeHeart.animation
        owner.lottieView.isHidden = false
        owner.lottieView.play()
        owner.cardTimeView.progressView.addGradientLayer()
        owner.cardTimeView.timerView.timerLabel.isHidden = true
        owner.cardTimeView.timerView.addGradientLayer()
      }
      .disposed(by: disposeBag)
    
    output.reportButtonAction
      .drive(with: self) { owner, _ in
        reportButtonTapTriggerObserver.onNext(())
        owner.pauseView.ImageContainerView.isHidden = true
        owner.pauseView.titleLabel.isHidden = true
      }
      .disposed(by: disposeBag)
    
    output.deleteCellAction
      .drive(with: self) { owner, _ in
        owner.pauseView.isHidden = true
        owner.profileCollectionView.showDimView()
      }
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
    let radius = CGFloat(rect.height / 2 - cardTimeView.timerView.strokeLayer.lineWidth / 2)
      
    // 3 / 2 pi(정점 각도) -> - 1 / 2 pi(정점)
    var angle = 2 * CGFloat.pi * progress - CGFloat.pi / 2 + CGFloat.pi / 10 // 두 원의 중점과 원점이 이루는 각도를 18도로 가정
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
      base.cardTimeView.timerView.trackLayer.strokeColor = timeState.trackLayerStrokeColor.color.cgColor
      base.cardTimeView.timerView.strokeLayer.strokeColor = timeState.timerTintColor.color.cgColor
      base.cardTimeView.timerView.dotLayer.strokeColor = timeState.timerTintColor.color.cgColor
      base.cardTimeView.timerView.dotLayer.fillColor = timeState.timerTintColor.color.cgColor
      base.cardTimeView.timerView.timerLabel.textColor = timeState.timerTintColor.color
      base.cardTimeView.progressView.progressBarColor = timeState.progressBarColor.color
      
      base.cardTimeView.timerView.dotLayer.isHidden = timeState.isDotHidden
      
      base.cardTimeView.timerView.timerLabel.text = timeState.getText
      
      base.cardTimeView.progressView.progress = timeState.getProgress
      
      // 소수점 3번 째자리까지 표시하면 오차가 발생해서 2번 째자리까지만 표시
      let strokeEnd = round(timeState.getProgress * 100) / 100
      
      base.cardTimeView.timerView.dotLayer.position = base.dotPosition(progress: strokeEnd, rect: base.cardTimeView.timerView.bounds)
      
      base.cardTimeView.timerView.strokeLayer.strokeEnd = strokeEnd
    }
  }
  
  var user: Binder<FallingUser> {
    return Binder(self.base) { base, user in
      base.bind(userProfilePhotos: user.userProfilePhotos)
      base.userInfoBoxView.bind(user)
      base.userInfoView.bind(user)
    }
  }
  
  var timerActiveAction: Binder<Bool> {
    return Binder(self.base) { base, value in
      if value {
        base.profileCollectionView.hiddenDimView()
        base.pauseView.isHidden = true
      } else {
        base.pauseView.ImageContainerView.isHidden = false
        base.pauseView.titleLabel.isHidden = false
        base.pauseView.isHidden = false
      }
    }
  }
}
