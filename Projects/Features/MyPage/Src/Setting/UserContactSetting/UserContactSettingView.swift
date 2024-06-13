//
//  UserContactSettingView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/10/24.
//

import UIKit

import DSKit

final class UserContactSettingView: TFBaseView {

  var tableView: UITableView!

  var emptyVIew = UIView().then {
    $0.backgroundColor = .clear
  }

  var cardView = UIImageView().then {
    $0.image = DSKitAsset.Bx.noBlocked.image
    $0.contentMode = .scaleAspectFill
  }

  override func makeUI() {
    tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    self.addSubview(tableView)

    emptyVIew.addSubview(cardView)

    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    tableView.backgroundView = emptyVIew

    cardView.snp.makeConstraints {
      $0.size.equalTo(250)
      $0.center.equalToSuperview()
    }
  }
}
