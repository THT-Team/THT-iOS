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
    self.mainView.setupDataSource()
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

    reactor.state.compactMap(\.sections)
      .subscribe(on: MainScheduler.instance)
      .filter { !$0.isEmpty }
      .do(onNext: { [weak self] sections in
          self?.mainView.applySnapshot(items: sections)
      })
      .subscribe(with: self) { owner, sections in
        owner.mainView.scrollToBottom()
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
