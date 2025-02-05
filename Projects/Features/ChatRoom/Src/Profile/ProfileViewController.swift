//
//  ProfileViewController.swift
//  ChatRoom
//
//  Created by Kanghos on 1/28/25.
//

import UIKit

import DSKit

import Domain
import RxSwift
import RxCocoa
import ReactorKit

public final class ProfileViewController: TFBaseViewController, View {
  private lazy var mainView = TFProfileView()
  public private(set) lazy var visualEffectView: UIVisualEffectView = {
    let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    visualView.isHidden = true
    return visualView
  }()

  public init(reactor: ProfileReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }

  public override func loadView() {
    self.view = mainView
  }

  public override func makeUI() {
    self.view.addSubview(visualEffectView)

    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  public func bind(reactor: ProfileReactor) {
    mainView.reportTap = {
      reactor.action.onNext(.reportTap)
    }
    Observable<Reactor.Action>.merge(
      self.rx.viewDidLoad.map { _ in .viewDidLoad },
      mainView.topicBarView.closeButton.rx.tap.map { _ in .closeTap }
    )
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    reactor.state.map(\.isBlurHidden)
      .bind(to: visualEffectView.rx.isHidden)
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.topic)
      .bind(to: self.mainView.rx.topicBar)
      .disposed(by: disposeBag)

    reactor.state.map(\.section)
      .bind(to: self.mainView.rx.sections)
      .disposed(by: disposeBag)
  }
}
