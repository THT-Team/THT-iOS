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
    $0.register(cellType: CellType.self)
  }

  lazy var emptyView = UIView().then {
    $0.backgroundColor = .clear
  }

  var cardView = UIImageView().then {
    $0.image = DSKitAsset.Bx.noBlocked.image
    $0.contentMode = .scaleAspectFill
  }

  override func makeUI() {
    addSubview(tableView)

    emptyView.addSubview(cardView)

    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    cardView.snp.makeConstraints {
      $0.size.equalTo(250)
      $0.center.equalToSuperview()
    }
  }
}
