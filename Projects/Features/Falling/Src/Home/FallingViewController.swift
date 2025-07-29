//
//  FallingViewController.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import DSKit
import FallingInterface
import Domain
import ReactorKit
import SwiftUI

final class FallingViewController: TFBaseViewController, ReactorKit.View {
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
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mindImageView)
    navigationItem.rightBarButtonItem = UIBarButtonItem.noti
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
      .bind(to: loadingView.rx.isLoading)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.snapshot)
      .distinctUntilChanged()
      .subscribe(with: self) { $0.initialSnapshot($1, animated: true) }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$scrollAction)
      .distinctUntilChanged()
      .compactMap { $0 }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { $0.homeView.scrollto($1) }
      .disposed(by: self.disposeBag)
    
    reactor.pulse(\.$deleteAnimationUser)
      .compactMap { $0 }
      .observe(on: MainScheduler.instance)
      .bind(with: self) { $0.deleteItem($1) }
      .disposed(by: disposeBag)
    
    reactor.pulse(\.$toast)
      .compactMap { $0 }
      .bind(to: TFToast.shared.rx.makeToast)
      .disposed(by: disposeBag)
    
    loadingView.closeButton.rx.tap
      .map { Reactor.Action.closeButtonTap }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func setUpCellResitration(_ reactor: FallingViewModel) {
    let userCardRegistration = ProfileCellRegistration { cell, indexPath, item in
      
      cell.bind(item)
      
      let timerActiveTrigger = reactor.state
        .distinctUntilChanged(\.scrollAction)
        .compactMap(\.user?.id)
        .debug("indexPath: ")
        .map { $0 == item.id }
      
      timerActiveTrigger
        .debug("\(indexPath) active")
        .bind(to: cell.activateCardSubject)
        .disposed(by: cell.disposeBag)
      
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
      
      reactor.pulse(\.$hideUserInfo)
        .bind(to: cell.userDetailInfoRelay)
        .disposed(by: cell.disposeBag)
      
      // MARK: Action Forwarding
      Observable<Reactor.Action>.merge(
        cell.rx.likeBtnTap.map { _ in .likeTap(item) },
        cell.rx.reportBtnTap.map { _ in .reportTap(item) },
        cell.rx.rejectBtnTap.map { _ in .rejectTap(item) },
        cell.rx.cardDoubleTap.map { .pauseTap(true) },
        cell.rx.pauseDoubleTap.map { .pauseTap(false) }
      )
      .bind(to: reactor.action)
      .disposed(by: cell.disposeBag)
    }
    
    let noticeRegistration = NoticeCellRegistration { cell, indexPath, item in
      cell.configure(type: item)
      
      cell.submitButton.rx.tap
        .map { item.toFallingAction() }
        .bind(to: reactor.action)
        .disposed(by: cell.disposeBag)
    }
    
    let dailyKeywordRegistration = DailyKeywordRegistration { cell, indexPath, item in
      let viewModel = TopicViewModel(delegate: self, dailyTopicKeyword: item)
      viewModel.delegate = self
      cell.contentConfiguration = UIHostingConfiguration {
        TopicView(viewModel: viewModel)
      }
    }
    
    let dummyUserRegistration = DummyUserRegistration { [weak self] cell, _, item  in
      guard let self = self else { return }
      cell.configure(dummyImage: item)
      
      cell.submitButton.rx.tap
        .map { Reactor.Action.dummyUserStartTap }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    let footerRegistration = UICollectionView.SupplementaryRegistration
    <DummyFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { _,_,_ in }
    
    dataSource = DataSource(collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      switch itemIdentifier {
      case .dailyKeyword(let dailyKeyword):
        collectionView.dequeueConfiguredReusableCell(
          using: dailyKeywordRegistration,
          for: indexPath,
          item: dailyKeyword
        )
      case .fallingUser(let user):
        collectionView.dequeueConfiguredReusableCell(
          using: userCardRegistration,
          for: indexPath,
          item: user
        )
      case .notice(let type, _):
        collectionView.dequeueConfiguredReusableCell(
          using: noticeRegistration,
          for: indexPath,
          item: type
        )
      case .dummyUser(let image, _):
        collectionView.dequeueConfiguredReusableCell(
          using: dummyUserRegistration,
          for: indexPath,
          item: image
        )
      }
    })
    
    dataSource.supplementaryViewProvider = { (view, _, index) in
      view.dequeueConfiguredReusableSupplementary(
        using: footerRegistration,
        for: index
      )
    }
  }
}

// MARK: DiffableDataSource

extension FallingViewController {
  typealias ModelType = FallingDataModel
  typealias SectionType = ProfileSection
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>
  typealias DailyKeywordRegistration = UICollectionView.CellRegistration<UICollectionViewCell, TopicDailyKeyword>
  typealias ProfileCellRegistration = UICollectionView.CellRegistration<FallingUserCollectionViewCell, FallingUser>
  typealias NoticeCellRegistration = UICollectionView.CellRegistration<NoticeViewCell, NoticeViewCell.Action>
  typealias DummyUserRegistration = UICollectionView.CellRegistration<DummyUserViewCell, UIImage>
  
  func initialSnapshot(_ items: [ModelType], animated: Bool) {
    var snapshot = Snapshot()
    snapshot.appendSections([.profile])
    snapshot.appendItems(items, toSection: .profile)
    self.dataSource.apply(snapshot, animatingDifferences: animated)
  }
  
  private func deleteItem(_ user: FallingUser) {
    guard let deleteIndexPath = self.dataSource.indexPath(for: .fallingUser(user)),
          let cell = self.homeView.collectionView.cellForItem(at: deleteIndexPath) as? FallingUserCollectionViewCell else { return }
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
      cell.transform = cell.transform.rotated(by: -.pi / 6).concatenating(cell.transform.translatedBy(x: cell.frame.minX - self.homeView.collectionView.frame.width, y: 37.62))
    } completion: { [weak self] _ in
      guard let self = self else { return }
      self.reactor?.action.onNext(.deleteAnimationComplete(user))
      TFLogger.ui.debug("delete animation did completed")
    }
  }
}

// MARK: TopicActionDelegate

extension FallingViewController: TopicActionDelegate {
  func didTapStartButton(topic: DailyKeyword) {
    reactor?.action.onNext(.tapTopicStart(topic))
  }
  
  func didFinishDailyTopic() {
    reactor?.action.onNext(.fetchDailyTopics)
  }
}
