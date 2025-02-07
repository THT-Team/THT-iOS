//
//  MyPageDefaultTableView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/14/24.
//

import UIKit

import DSKit

class MyPageDefaultTableView<CellType: MyPageDefaultTableViewCell>: TFBaseView {

  lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
    $0.showsVerticalScrollIndicator = false
    $0.backgroundView = emptyView
    $0.separatorStyle = .none
    $0.backgroundColor = DSKitAsset.Color.neutral700.color

    $0.register(cellType: CellType.self)
  }

  lazy var backButton = UIButton.makeBackButton()

  lazy var titleLabel = UILabel().then {
    $0.font = UIFont.thtH4Sb
    $0.textColor = DSKitAsset.Color.neutral50.color
    $0.text = "설정관리"
  }

  private lazy var headerView = UIStackView(arrangedSubviews: [backButton, titleLabel]).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
    $0.distribution = .equalSpacing
    $0.spacing = 12
  }

  lazy var emptyView = UIView().then {
    $0.backgroundColor = .clear
  }

  var cardView = UIImageView().then {
    $0.image = DSKitAsset.Bx.noBlocked.image
    $0.contentMode = .scaleAspectFill
  }

  override func makeUI() {
    addSubviews(headerView, tableView)

    emptyView.addSubview(cardView)

    headerView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(56)
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    cardView.snp.makeConstraints {
      $0.size.equalTo(250)
      $0.center.equalToSuperview()
    }
  }
}
