//
//  HeartListViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/07/11.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

final class HeartListViewController: TFBaseViewController {

  private let viewModel: HeartListViewModel
  private lazy var tableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .grouped)
    tableView.register(cellType: HeartListTableViewCell.self)
    tableView.backgroundColor = FallingAsset.Color.neutral700.color
    tableView.rowHeight = 84 + (12 * 2)
    return tableView
  }()

  init(viewModel: HeartListViewModel) {
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

    navigationItem.title = "나를 좋아요한 무디"
    let noti = UIBarButtonItem(image: FallingAsset.Image.bell.image, style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = noti
  }

  private let emptyView = TFEmptyView(
    image: FallingAsset.Bx.noLike.image,
    title: "아직 만난 무디가 없네요.",
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
    let input = HeartListViewModel.Input(

    )
    Driver.just([1,2,3])
      .debug()
      .drive(self.tableView.rx.items(cellIdentifier: HeartListTableViewCell.reuseIdentifier, cellType: HeartListTableViewCell.self)) { value, row, cell in
        cell.configure()
      }.disposed(by: self.disposeBag)
    emptyView.isHidden = true

    let output = viewModel.transform(input: input)

  }

  deinit {
    print("[Deinit]: \(self)")
  }
}
