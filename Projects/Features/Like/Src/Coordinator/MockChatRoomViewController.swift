//
//  MockChatRoomViewController.swift
//  Like
//
//  Created by Kanghos on 2024/05/03.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa

final class MockChatRoomViewController: TFBaseViewController {

  weak var delegate: ChatRoomActionDelegate?

  private let label: UILabel = {
    let label = UILabel()
    label.text = "Mock Chat Room"
    label.font = .thtH1B
    return label
  }()

  override func makeUI() {
    self.view.addSubview(label)

    label.center = self.view.center
  }

  override func navigationSetting() {
    super.navigationSetting()

  }

  override func bindViewModel() {
    backButton.rx.tap
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.finish)
      }.disposed(by: disposeBag)
  }
}
