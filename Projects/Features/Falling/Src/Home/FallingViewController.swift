//
//  FallingViewController.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import Core
import DSKit
import FallingInterface
import Domain
import ReactorKit

final class FallingViewController: TFBaseViewController, View {
  private var dataSource: DataSource!
  
  private let homeView = FallingView()
  private let loadingView = TFLoadingView()
  
  init(viewModel: FallingViewModel) {
    defer { self.reactor = viewModel }
    super.init(nibName: nil, bundle: nil)
  }
  
  override func loadView() {
    self.view = homeView
  }
  
  override func makeUI() {
    if let navigationController = self.navigationController {
      loadingView.frame = navigationController.view.frame
      navigationController.view.addSubview(loadingView)
    }
  }

  override func navigationSetting() {
    super.navigationSetting()
    
    navigationItem.title = "가치관"
    let mindImageView = UIImageView(image: DSKitAsset.Image.Icons.mind.image)
    let mindImageItem = UIBarButtonItem(customView: mindImageView)
    
    let notificationButtonItem = UIBarButtonItem.noti
    
    navigationItem.leftBarButtonItem = mindImageItem
    navigationItem.rightBarButtonItem = notificationButtonItem
  }

  func bind(reactor: FallingViewModel) {
    setUpCellResitration(reactor)

    Observable<Reactor.Action>.merge(
      rx.viewDidLoad.map { .viewDidLoad },
      rx.viewWillDisAppear.mapToVoid().map { .viewWillDisappear }
    )
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    reactor.pulse(\.$isLoading)
      .map { !$0 }
      .bind(to: loadingView.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.state.map(\.snapshot)
      .distinctUntilChanged()
//      .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
      .subscribe(with: self) { owner, list in
        var snapshot = Snapshot()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list, toSection: .profile)
        owner.dataSource.apply(snapshot, animatingDifferences: true)
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$scrollAction)
      .distinctUntilChanged()
      .asDriverOnErrorJustEmpty()
      .drive(with: self, onNext: { owner, action in
        switch action {
        case .scroll(let indexPath):
          owner.homeView.collectionView.scrollToItem(
            at: indexPath,
            at: .top,
            animated: true
          )
          TFLogger.ui.debug("scroll to Item at: \(indexPath)")
        case let .scrollAfterDelete(user):
          owner.deleteItem(user)
        default: break
        }
      })
      .disposed(by: self.disposeBag)

    reactor.pulse(\.$toast)
      .compactMap { $0 }
      .bind(with: self, onNext: { owner, message in
        owner.homeView.makeToast(message, duration: 3.0, position: .bottom)
      })
      .disposed(by: disposeBag)
  }

  func setUpCellResitration(_ reactor: FallingViewModel) {
    let currentIdentifier = reactor.state
      .distinctUntilChanged(\.scrollAction)
      .compactMap(\.user?.id)
      .debug("indexPath: ")

    let userProfileCellRegistration = ProfileCellRegistration { cell, indexPath, item in

      let timerActiveTrigger = currentIdentifier
        .map { $0 == item.id }

      // MARK: State Binding
      timerActiveTrigger
        .debug("\(indexPath) active")
        .bind(to: cell.activateCardSubject)
        .disposed(by: cell.disposeBag)

      Driver.just(item)
        .drive(cell.rx.user)
        .disposed(by: cell.disposeBag)

      cell.userInfoView.sections = item.toUserCardSection()

      reactor.pulse(\.$timeState)
        .withLatestFrom(timerActiveTrigger) { ($0, $1) }
        .filter { _, isActive in isActive }
        .map { timeState, _ in timeState }
        .bind(to: cell.rx.timeState)
        .disposed(by: cell.disposeBag)

      reactor.pulse(\.$shouldShowPause)
        .withLatestFrom(timerActiveTrigger) { ($0, $1) }
        .filter { _, isActive in isActive }
        .map { shouldSHowPause, _ in !shouldSHowPause }
        .bind(to: cell.pauseViewRelay)
        .disposed(by: cell.disposeBag)

      // MARK: Action Forwarding
      Driver.merge(
        cell.rx.likeBtnTap.asDriver(),
        cell.rx.reportBtnTap.asDriver(),
        cell.rx.rejectBtnTap.asDriver(),
        cell.rx.cardDoubleTap.asDriver(),
        cell.rx.pauseDoubleTap.asDriver()
      )
      .map(Reactor.Action.cellButtonAction)
      .drive(reactor.action)
      .disposed(by: cell.disposeBag)
    }

    let noticeRegistration = UICollectionView.CellRegistration<NoticeViewCell, NoticeViewCell.Action> { cell, indexPath, item in
      cell.configure(type: item)

      cell.summitButton.rx.tap.map { item }
        .map(Reactor.Action.noticeButtonAction)
        .bind(to: reactor.action)
        .disposed(by: cell.disposeBag)
    }

    let footerRegistration = UICollectionView.SupplementaryRegistration
    <DummyFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { _,_,_ in }

    dataSource = DataSource(collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      switch itemIdentifier {
      case .fallingUser(let user):
        return collectionView.dequeueConfiguredReusableCell(
          using: userProfileCellRegistration,
          for: indexPath,
          item: user
        )
      case .notice(let type, let id):
        return collectionView.dequeueConfiguredReusableCell(
          using: noticeRegistration,
          for: indexPath,
          item: type
        )
      }
    })

    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return view.dequeueConfiguredReusableSupplementary(
        using: footerRegistration,
        for: index
      )
    }

    initialSnapshot()
  }
}

// MARK: DiffableDataSource

extension FallingViewController {
  typealias ModelType = FallingDataModel
  typealias SectionType = ProfileSection
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>
  typealias ProfileCellRegistration = UICollectionView.CellRegistration<FallingUserCollectionViewCell, FallingUser>
  typealias NoticeCellRegistration = UICollectionView.CellRegistration<NoticeViewCell, NoticeViewCell.Action>

  func initialSnapshot() {
    var snapshot = Snapshot()
    snapshot.appendSections([.profile])
    self.dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  private func deleteItem(_ user: FallingUser) {
    guard let deleteIndexPath = self.dataSource.indexPath(for: .fallingUser(user)),
          let cell = self.homeView.collectionView.cellForItem(at: deleteIndexPath) as? FallingUserCollectionViewCell else { return }
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      cell.transform = cell.transform.rotated(by: -.pi / 6).concatenating(cell.transform.translatedBy(x: cell.frame.minX - self.homeView.collectionView.frame.width, y: 37.62))
    } completion: { [weak self] _ in
      self?.reactor?.action.onNext(.deleteAnimationComplete(user))
      TFLogger.ui.debug("delete animation did completed")
    }
  }
}

enum FallingDataModel: Hashable, Equatable {
  case fallingUser(FallingUser)
  case notice(NoticeViewCell.Action, UUID)

  func hash(into hasher: inout Hasher) {
    switch self {
    case .fallingUser(let fallingUser):
      hasher.combine(fallingUser)
    case let .notice(_, id):
      hasher.combine(id)
    }
  }
}

