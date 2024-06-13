//
//  AccountSettingView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/13/24.
//

import UIKit

import DSKit

final class AccountSettingView: TFBaseView {

  var tableView: UITableView!

  var emptyVIew = UIView().then {
    $0.backgroundColor = .clear
  }

  var cardView = UIImageView().then {
    $0.image = DSKitAsset.Bx.noBlocked.image
    $0.contentMode = .scaleAspectFill
  }

  var deactivateBtn = UIButton().then {
    $0.setTitle("탈퇴하기", for: .normal)
    $0.setTitleColor(.red, for: .normal)
    $0.titleLabel?.font = .systemFont(ofSize: 16)
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.red.cgColor
  }

  override func makeUI() {
    tableView = UITableView(frame: .zero, style: .insetGrouped)
    tableView.showsVerticalScrollIndicator = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    self.addSubview(tableView)
    self.addSubviews(deactivateBtn)

    emptyVIew.addSubview(cardView)

    tableView.snp.makeConstraints {
      $0.edges.equalTo(safeAreaLayoutGuide)
    }

    tableView.backgroundView = emptyVIew

    cardView.snp.makeConstraints {
      $0.size.equalTo(250)
      $0.center.equalToSuperview()
    }

    deactivateBtn.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(50)
      $0.bottom.equalToSuperview().offset(-30)
    }
  }
}
