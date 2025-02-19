//
//  ChatRoomViewController.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import Core
import DSKit
import Domain
import ReactorKit

final class ChatRoomViewController: TFBaseViewController, View {
  typealias Reactor = ChatRoomReactor
  private lazy var mainView = ChatRoomView()
  private var dataSource: DataSource!

  init(reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  override func loadView() {
    self.view = mainView
  }

  override func navigationSetting() {
    super.navigationSetting()

    navigationItem.leftBarButtonItem = self.mainView.backButton
    navigationItem.rightBarButtonItems = [self.mainView.exitButton, self.mainView.reportButton, ]
  }

  func bind(reactor: Reactor) {
    self.setupDataSource()
    // Action
    Observable<Reactor.Action>.merge(
      NotificationCenter.default.rx.notification(UIScene.didEnterBackgroundNotification)
        .map { _ in Reactor.Action.didEnterBackground },
      NotificationCenter.default.rx.notification(UIScene.willEnterForegroundNotification)
        .map { _ in Reactor.Action.willEnterForeground },
      rx.viewDidLoad.map { _ in Reactor.Action.viewDidLoad },
//      mainView.chatInputView.rx.sendButtonTap.map(Reactor.Action.send),
      mainView.backButton.rx.tap.map { Reactor.Action.onBackBtnTap },
      mainView.reportButton.rx.tap.map { Reactor.Action.onReportBtnTap },
      mainView.exitButton.rx.tap.map { Reactor.Action.onExitBtnTap }
    )
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    mainView.chatInputView.rx.sendButtonTap
      .withLatestFrom(reactor.state.map(\.info)) { Reactor.Action.send($0, $1) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    // State
    reactor.state.compactMap(\.info)
      .subscribe(with: self) { owner, info in
        owner.title = info.title ?? "Partner's name"
        owner.mainView.topicBind(info.talkSubject, info.talkIssue)
      }
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.sections.first)
      .subscribe(on: MainScheduler.instance)
      .do(onNext: { [weak self] section in
        self?.applySnapshot(items: section.items)
      })
      .subscribe(with: self) { owner, section in
        owner.mainView.collectionView.scrollToItem(at: IndexPath(item: section.items.count - 1, section: 0), at: .bottom, animated: true)
      }
      .disposed(by: disposeBag)
    reactor.state.compactMap(\.isBlurHidden)
      .bind(to: mainView.visualEffectView.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.pulse(\.$toast)
      .compactMap { $0 }
      .bind(to: TFToast.shared.rx.makeToast)
      .disposed(by: disposeBag)
  }
}

extension ChatRoomViewController {
  typealias Model = ChatViewSectionItem
  typealias DataSource = UICollectionViewDiffableDataSource<ChatViewSectionKind, Model>
  typealias Snapshot = NSDiffableDataSourceSnapshot<ChatViewSectionKind, Model>
  typealias OutgoingCellRegistration = UICollectionView.CellRegistration<BaseBubbleCell, BubbleReactor>
  typealias IncomingCellRegistration = UICollectionView.CellRegistration<IncomingBubbleCell, BubbleReactor>
  typealias DateReusableViewRegistration = UICollectionView.SupplementaryRegistration<DateReusableView>

  func setupDataSource() {
    let bubbleRegistration = OutgoingCellRegistration { cell, _, item in
      cell.bind(reactor: item)
    }

    let myBubbleRegistration = IncomingCellRegistration { [weak self] cell, _, item in
      guard let self else { return }
      cell.bind(reactor: item)
    }

    let dateSupplementRegistration = DateReusableViewRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, _ in
      supplementaryView.bind("헤더")
    }

    self.dataSource = DataSource(collectionView: self.mainView.collectionView) { collectionView, indexPath, item in
      switch item {
      case let .incoming(reactor):
        collectionView.dequeueConfiguredReusableCell(using: myBubbleRegistration, for: indexPath, item: reactor)
      case let .outgoing(reactor):
        collectionView.dequeueConfiguredReusableCell(using: bubbleRegistration, for: indexPath, item: reactor)
      }
    }

    self.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      collectionView.dequeueConfiguredReusableSupplementary(using: dateSupplementRegistration, for: indexPath)
    }

    applySnapshot(items: [])
  }

  func applySnapshot(items: [ChatViewSectionItem]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(items, toSection: .main)

    dataSource.apply(snapshot)
  }
}
