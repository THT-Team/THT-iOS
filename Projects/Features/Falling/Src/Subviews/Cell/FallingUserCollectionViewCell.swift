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

  lazy var carouselView = TFCarouselView().then {
    $0.backgroundColor = DSKitAsset.Color.DimColor.default.color
    $0.layer.cornerRadius = 20
    $0.layer.masksToBounds = true
    $0.carouselView.isScrollEnabled = false
  }

  lazy var userInfoBoxView = UserInfoBoxView()
  lazy var cardTimeView = CardTimeView()
  lazy var pauseView = PauseView()

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

  // MARK: State
  let lottieRelay = PublishRelay<AnimationAsset>()
  let userDetailInfoRelay = PublishRelay<Bool>()
  let pauseViewRelay = PublishRelay<Bool>()
  let dimViewRelay = PublishRelay<Bool>()
  let activateCardSubject = BehaviorSubject(value: false)

  var isActivate = false

  override func makeUI() {
    self.layer.cornerRadius = 20
    self.layer.masksToBounds = true

    self.contentView.addSubviews([carouselView, cardTimeView, userInfoBoxView, userInfoBoxView, userInfoView, lottieView, pauseView])

    carouselView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    self.cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(carouselView).inset(12)
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

    self.setDataSource()

    bind()
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    bind()
    // MARK: Init
    cardTimeView.bind(.none)
    cardTimeView.hideTimerGradient()
    userInfoView.isHidden = true
  }

  func bind() {
    let lottieSignal: Signal<AnimationAsset> = lottieRelay.asSignal()
    let userDetailInfoSignal: Signal<Bool> = userDetailInfoRelay.asSignal()
    let pauseViewSignal = pauseViewRelay.asSignal()
    let dimViewSignal = dimViewRelay.asSignal()

    pauseViewSignal
      .emit(to: pauseView.rx.isPauseViewHidden)
      .disposed(by: disposeBag)

    dimViewSignal
      .emit(with: self) { owner, isHidden in
        isHidden
        ? owner.carouselView.hiddenDimView()
        : owner.carouselView.showDimView()
      }.disposed(by: disposeBag)

    lottieSignal
      .emit(with: self) { owner, lottie in
        owner.lottieView.animation = lottie.animation
        owner.lottieView.isHidden = false
        owner.lottieView.play { completed in
          owner.lottieView.isHidden = true
        }
      }.disposed(by: disposeBag)

    activateCardSubject.asSignal(onErrorSignalWith: .empty())
      .emit(to: self.rx.isDimViewHidden)
      .disposed(by: disposeBag)

    userDetailInfoSignal
      .emit(to: userInfoView.rx.isHidden)
      .disposed(by: disposeBag)

    self.userInfoBoxView.infoButton.rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .scan(true) { latest, _ in !latest }
      .bind(to: userDetailInfoRelay)
      .disposed(by: disposeBag)
  }

  func bind(userProfilePhotos: [UserProfilePhoto]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.profile])
    snapshot.appendItems(userProfilePhotos)
    self.dataSource.apply(snapshot)

    self.carouselView.pageControl.numberOfPages = userProfilePhotos.count
  }
}

extension FallingUserCollectionViewCell {
  var activateState: Observable<Bool> {
    self.activateCardSubject.share()
      .debug("active state")
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

    self.dataSource = UICollectionViewDiffableDataSource(collectionView: carouselView.carouselView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
  }
}

extension FallingUserCollectionViewCell {
  enum Action {
    case likeTap
    case rejectTap
    case reportTap
    case pause(Bool)
  }
}

// MARK: ControlEvent

extension Reactive where Base: FallingUserCollectionViewCell {

  var likeBtnTap: ControlEvent<Base.Action> {
    let source: Observable<Base.Action> = self.base.userInfoBoxView.likeButton.rx.tap
      .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(Base.Action.likeTap)
        : .empty()
      }
      .do { [weak base = self.base] _ in
        base?.lottieRelay.accept(.likeHeart)
        base?.cardTimeView.bind(.none)
        base?.cardTimeView.showTimerGradient()
      }
    return ControlEvent(events: source)
  }

  var rejectBtnTap: ControlEvent<Base.Action> {
    let source: Observable<Base.Action> = self.base.userInfoBoxView.rejectButton.rx.tap
      .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(Base.Action.rejectTap)
        : .empty()
      }
      .do { [weak base = self.base] _ in
        base?.lottieRelay.accept(.unlike)
        base?.cardTimeView.bind(.none)
        base?.cardTimeView.hideTimerGradient()
      }
    return ControlEvent(events: source)
  }

  var reportBtnTap: ControlEvent<Base.Action> {
    let source: Observable<Base.Action> = self.base.userInfoView.reportButton.rx.tap
      .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(Base.Action.reportTap)
        : .empty()
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.pauseView.showBlurView()
      })

    return ControlEvent(events: source)
  }

  var cardDoubleTap: ControlEvent<Base.Action> {
    let source = self.base.carouselView.carouselView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(.pause(true))
        : .empty()
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.pauseViewRelay.accept(false)
      })

    return ControlEvent(events: source)
  }

  var pauseDoubleTap: ControlEvent<Base.Action> {
    let source = self.base.pauseView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(.pause(false))
        : .empty()
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.pauseViewRelay.accept(true)
      })

    return ControlEvent(events: source)
  }
}

// MARK: Binder

extension Reactive where Base == FallingUserCollectionViewCell {

  var timeState: Binder<TimeState> {
    return Binder(self.base) { (base, timeState) in
      base.cardTimeView.bind(timeState)
    }
  }

  var user: Binder<FallingUser> {
    return Binder(self.base) { base, user in
      base.bind(userProfilePhotos: user.userProfilePhotos)
      base.userInfoBoxView.bind(user)
      base.userInfoView.bind(user)
    }
  }
  var isDimViewHidden: Binder<Bool> {
    return Binder(self.base) { (base, isHidden) in
      isHidden ? base.carouselView.hiddenDimView() : base.carouselView.showDimView()
    }
  }
}
