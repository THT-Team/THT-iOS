//
//  MySettingView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

import DSKit

final class MySettingView: TFBaseView {

  var tableView: UITableView!

  override func makeUI() {
    tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    self.addSubview(tableView)

    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }
  }
}
