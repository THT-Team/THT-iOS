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

final class FallingUserCollectionViewCell: TFBaseCollectionViewCell {
  
  private var dataSource: DataSource!
  var timer: TFTimer?
  
  lazy var containerView: UIView = {
    let view = UIView(frame: bounds)
    return view
  }()
  
  let carouselView = TFCarouselView().then {
    $0.backgroundColor = DSKitAsset.Color.DimColor.default.color
    $0.layer.cornerRadius = 20
    $0.layer.masksToBounds = true
    $0.collectionView.isScrollEnabled = false
  }
  
  let cardTimeView = CardTimeView()
  
  private let labelContainerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 6
    stackView.alignment = .leading
    stackView.isUserInteractionEnabled = false
    return stackView
  }()
  
  private let nicknameWithAgeStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.alignment = .leading
    return stackView
  }()
  
  private let nicknameLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtEx4Sb
    label.setTextWithLineHeight(text: "닉네임", lineHeight: 29)
    return label
  }()
  
  private let ageLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtEx4Sb
    label.setTextWithLineHeight(text: "0", lineHeight: 29)
    return label
  }()
  
  private let addressStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 4
    return stackView
  }()
  
  private let pinImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = DSKitAsset.Image.Icons.pinSmall.image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.textColor = DSKitAsset.Color.neutral50.color
    label.font = UIFont.thtP2M
    label.setTextWithLineHeight(text: "주소", lineHeight: 17)
    return label
  }()
  
  private let bottomRightButtonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 20
    return stackView
  }()
  
  let infoButton = CardButton(type: .info)
  let rejectButton = CardButton(type: .reject)
  let likeButton = CardButton(type: .like)
  
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
    
    self.contentView.addSubviews([containerView, pauseView])
    
    self.containerView.addSubviews([carouselView, cardTimeView, labelContainerStackView, infoButton, bottomRightButtonStackView, userInfoView, lottieView])
    
    labelContainerStackView.addArrangedSubviews([nicknameWithAgeStackView, addressStackView])
    
    nicknameWithAgeStackView.addArrangedSubviews([nicknameLabel, ageLabel])
    
    addressStackView.addArrangedSubviews([pinImageView, addressLabel])
    
    bottomRightButtonStackView.addArrangedSubviews([rejectButton, likeButton])
    
//    containerView.snp.makeConstraints {
//      $0.edges.equalToSuperview()
//    }
    
    self.pauseView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    carouselView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    self.cardTimeView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(carouselView).inset(12)
      $0.height.equalTo(32)
    }
    
    pinImageView.snp.makeConstraints {
      $0.height.equalTo(18)
    }
    
    infoButton.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(32)
      $0.size.equalTo(58)
    }
    
    [rejectButton, likeButton].forEach { view in
      view.snp.makeConstraints {
        $0.size.equalTo(58)
      }
    }
    
    bottomRightButtonStackView.snp.makeConstraints {
      $0.right.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(32)
    }
    
    labelContainerStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().inset(16)
      $0.bottom.equalTo(infoButton.snp.top).offset(-14)
    }
    
    userInfoView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.height.greaterThanOrEqualTo(150)
      $0.bottom.equalTo(labelContainerStackView.snp.top).offset(-8)
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
    userInfoView.sections = []
  }
  
  func bind() {
    let lottieSignal: Signal<AnimationAsset> = lottieRelay.asSignal()
    let userDetailInfoSignal: Signal<Bool> = userDetailInfoRelay.asSignal()
    let pauseViewSignal = pauseViewRelay.asSignal()
    let dimViewSignal = dimViewRelay.asSignal()
    
    pauseViewSignal
      .emit(to: rx.isPauseViewHidden)
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
    
    self.infoButton.rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .scan(true) { latest, _ in !latest }
      .bind(to: userDetailInfoRelay)
      .disposed(by: disposeBag)
  }
  
  func bind(_ item: FallingUser, timer: TFTimer) {
    self.timer = timer
    bind(user: item)
    userInfoView.sections = item.toUserCardSection()
    bind(userProfilePhotos: item.userProfilePhotos)
  }
  
  private func bind(user: FallingUser) {
    self.nicknameLabel.text = "\(user.username),"
    self.ageLabel.text = "\(user.age)"
    self.addressLabel.text = "\(user.address), \(user.distance.formatDistance())"
  }
  
  private func bind(userProfilePhotos: [UserProfilePhoto]) {
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
  typealias DataSource = UICollectionViewDiffableDataSource<ProfileSection, Model>
  typealias Snapshot = NSDiffableDataSourceSnapshot<ProfileSection, Model>
  
  func setDataSource() {
    let profileCellRegistration = UICollectionView.CellRegistration<ProfileCollectionViewCell, Model> { cell, indexPath, item in
      cell.bind(imageURL: item.url)
    }
    
    self.dataSource = UICollectionViewDiffableDataSource(collectionView: carouselView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
  }
  
  func applyBlur() {
    containerView.blur(blurRadius: 16)
    contentView.bringSubviewToFront(pauseView)
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
    let source: Observable<Base.Action> = self.base.likeButton.rx.tap
      .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(Base.Action.likeTap)
        : .empty()
      }
      .do { [weak base = self.base] _ in
        base?.timer?.cancel()
        base?.lottieRelay.accept(.likeHeart)
        base?.cardTimeView.bind(.none)
        base?.cardTimeView.showTimerGradient()
      }
      .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    return ControlEvent(events: source)
  }
  
  var rejectBtnTap: ControlEvent<Base.Action> {
    let source: Observable<Base.Action> = self.base.rejectButton.rx.tap
      .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Base.Action> in
        return isActivate
        ? .just(Base.Action.rejectTap)
        : .empty()
      }
      .do { [weak base = self.base] _ in
        base?.timer?.cancel()
        base?.lottieRelay.accept(.unlike)
        base?.cardTimeView.bind(.none)
        base?.cardTimeView.hideTimerGradient()
      }
      .delay(.milliseconds(300), scheduler: MainScheduler.instance)
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
        base?.timer?.cancel()
        base?.cardTimeView.bind(.none)
        base?.pauseView.showBlurView()
        base?.applyBlur()
      })
    
    return ControlEvent(events: source)
  }
  
  var cardDoubleTap: ControlEvent<Void> {
    let source = self.base.carouselView.collectionView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Void> in
        return isActivate
        ? .just(())
        : .empty()
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.pauseViewRelay.accept(false)
      })
    
    return ControlEvent(events: source)
  }
  
  var pauseDoubleTap: ControlEvent<Void> {
    let source = self.base.pauseView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .withLatestFrom(self.base.activateCardSubject)
      .flatMap { isActivate -> Observable<Void> in
        return isActivate
        ? .just(())
        : .empty()
      }
      .do(onNext: { [weak base = self.base] _ in
        base?.pauseViewRelay.accept(true)
      })
    
    return ControlEvent(events: source)
  }
}

// MARK: Binder

extension Reactive where Base: FallingUserCollectionViewCell {
  
  var timeState: Binder<TimeState> {
    return Binder(self.base) { (base, timeState) in
      base.cardTimeView.bind(timeState)
    }
  }
  
  var isDimViewHidden: Binder<Bool> {
    return Binder(self.base) { (base, isHidden) in
      isHidden ? base.carouselView.hiddenDimView() : base.carouselView.showDimView()
    }
  }
  
  var isPauseViewHidden: Binder<Bool> {
    return Binder(self.base) { (base, isHidden) in
      if isHidden {
        base.pauseView.hide()
        base.containerView.unBlur()
      } else {
        base.pauseView.showPauseView()
        base.applyBlur()
      }
    }
  }
}
