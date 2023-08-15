//
//  ChatListViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/07/11.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class ChatListViewController: TFBaseViewController {

  private let viewModel: ChatListViewModel
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.register(cellType: ChatListTableViewCell.self)
    tableView.backgroundColor = FallingAsset.Color.neutral700.color
    tableView.rowHeight = 50 + (13 * 2)
    return tableView
  }()

  init(viewModel: ChatListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func navigationSetting() {
    super.navigationSetting()

    let defaultNavigationSetting = UINavigationBarAppearance()
    defaultNavigationSetting.titlePositionAdjustment.horizontal = -CGFloat.greatestFiniteMagnitude
    defaultNavigationSetting.titleTextAttributes = [.font: UIFont.thtH4Sb, .foregroundColor: FallingAsset.Color.neutral50.color]
    defaultNavigationSetting.backgroundColor = FallingAsset.Color.neutral700.color
    defaultNavigationSetting.shadowColor = nil
    navigationItem.standardAppearance = defaultNavigationSetting
    navigationItem.scrollEdgeAppearance = defaultNavigationSetting

    navigationItem.title = "채팅"
    let noti = UIBarButtonItem(image: FallingAsset.Image.bell.image, style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = noti

  }

  private let emptyView = TFEmptyView(
    image: FallingAsset.Bx.noMudy.image,
    title: "진행 중인 대화가 없어요",
    subTitle: "먼저 마음이 잘 맞는 무디들을 찾아볼까요?",
    buttonTitle: "무디들 만나러 가기"
  )

  override func makeUI() {
    self.view.addSubview(tableView)
    self.view.addSubview(emptyView)

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    emptyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func bindViewModel() {
    let selected = self.tableView.rx.itemSelected.map { $0.item }.asDriver(onErrorJustReturn: 0)
    let input = ChatListViewModel.Input(
      selectedRoom: selected
    )
    Driver.just([1,2,3])
      .debug()
      .drive(self.tableView.rx.items(cellIdentifier: ChatListTableViewCell.reuseIdentifier, cellType: ChatListTableViewCell.self)) { value, row, cell in
        cell.configure()
      }.disposed(by: self.disposeBag)

    emptyView.isHidden = true

    let output = viewModel.transform(input: input)
    output.toRoom
      .drive()
      .disposed(by: disposeBag)
  }

  deinit {
    print("[Deinit]: \(self)")
  }
}

extension ChatListViewController: UITableViewDelegate {

}
