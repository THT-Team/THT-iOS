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

final class FallingViewController: TFBaseViewController {
  private let viewModel: FallingViewModel
  private var dataSource: DataSource!
  
  private let homeView = FallingView()
  private let loadingView = TFLoadingView()
  
  init(viewModel: FallingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
  
  private let deleteAnimationComplete = PublishRelay<Void>()
  
  override func bindViewModel() {
    let viewDidLoad = Driver.just(())
    let fallingCellButtonAction = PublishSubject<FallingUserCollectionViewCell.Action>()
    let noticeButtonAction = PublishSubject<NoticeViewCell.Action>()
    let viewWillDisAppear = self.rx.viewWillDisAppear.asDriver().map { _ in
    }
    
    let input = FallingViewModel.Input(
      viewDidLoad: viewDidLoad.map { _ in FallingViewModel.ReloadAction.viewDidLoad },
      viewWillDisappear: viewWillDisAppear,
      cellButtonAction: fallingCellButtonAction.asDriverOnErrorJustEmpty(),
      deleteAnimationComplete: deleteAnimationComplete.asSignal(),
      noticeButtonAction: noticeButtonAction.asDriverOnErrorJustEmpty().map { FallingViewModel.ReloadAction.noticeButtonAction($0) }
    )
    
    let output = viewModel.transform(input: input)
    
    let currentIdentifier = output.state
      .distinctUntilChanged(\.scrollAction)
      .compactMap(\.user?.id)
      .debug("state IndexPaht: ")
    
    self.viewModel.pulse(\.$isLoading)
      .map { !$0 }
      .bind(to: loadingView.rx.isHidden)
      .disposed(by: disposeBag)
    
    let userProfileCellRegistration = UICollectionView.CellRegistration<FallingUserCollectionViewCell, FallingUser> { [weak self] cell, indexPath, item in
      guard let self = self else { return }
      
      let timerActiveTrigger = currentIdentifier
        .map { $0 == item.id }
      
      // MARK: State Binding
      timerActiveTrigger
        .debug("\(indexPath) active")
        .drive(cell.activateCardSubject)
        .disposed(by: cell.disposeBag)
      
      Driver.just(item)
        .drive(cell.rx.user)
        .disposed(by: cell.disposeBag)
      
      self.viewModel.pulse(\.$timeState)
        .asDriverOnErrorJustEmpty()
        .withLatestFrom(timerActiveTrigger) { ($0, $1) }
        .filter { _, isActive in isActive }
        .map { timeState, _ in timeState }
        .drive(cell.rx.timeState)
        .disposed(by: cell.disposeBag)
            
      self.viewModel.pulse(\.$shouldShowPause)
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
      .drive(fallingCellButtonAction)
      .disposed(by: cell.disposeBag)
    }
    
    let noticeRegistration = UICollectionView.CellRegistration<NoticeViewCell, NoticeViewCell.Action> { cell, indexPath, item in
      cell.configure(type: item)
      
      cell.summitButton.rx.tap.map { item }.asDriverOnErrorJustEmpty()
        .drive(noticeButtonAction)
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
      case .notice(let type):
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
    
    output.state.map(\.snapshot)
      .distinctUntilChanged()
      .drive(with: self, onNext: { owner, list in
        var snapshot = Snapshot()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list, toSection: .profile)
        //        owner.dataSource.applySnapshotUsingReloadData(snapshot)
        owner.dataSource.apply(snapshot, animatingDifferences: true)
      }).disposed(by: disposeBag)
    
    viewModel.pulse(\.$scrollAction)
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
    
    viewModel.pulse(\.$toast)
      .compactMap { $0 }
      .bind(with: self, onNext: { owner, message in
        owner.homeView.makeToast(message, duration: 3.0, position: .bottom)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: DiffableDataSource

extension FallingViewController {
  typealias ModelType = FallingDataModel
  typealias SectionType = FallingProfileSection
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>
  
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
      self?.deleteAnimationComplete.accept(())
      TFLogger.ui.debug("delete animation did completed")
    }
  }
}

extension FallingViewController {
  enum FallingDataModel: Hashable, Equatable {
    case fallingUser(FallingUser)
    case notice(NoticeViewCell.Action)
  }
}
