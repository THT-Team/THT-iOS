//
//  MySettingView.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

import DSKit

import MyPageInterface

final class MySettingView: TFBaseView {
  var sections: [SectionModel<MySetting.MenuItem>] = [] {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }

  lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
    $0.showsVerticalScrollIndicator = false
    $0.separatorStyle = .none
    $0.backgroundColor = DSKitAsset.Color.neutral700.color

    $0.register(cellType: MyPageDefaultTableViewCell.self)
    $0.register(cellType: BannerCell.self)
  }

  override func makeUI() {
    tableView.delegate  = self
    tableView.dataSource = self

    self.backgroundColor = DSKitAsset.Color.neutral700.color
    addSubviews(tableView)

    tableView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(56.adjustedH)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension MySettingView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let header = UIView()

    let label = UILabel().then {
      $0.text = sections[section].type.header
      $0.font = UIFont.thtP1R
      $0.textColor = DSKitAsset.Color.neutral300.color
    }

    header.addSubview(label)
    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-5)
    }

    return header
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

    let header = UIView()

    let label = UILabel().then {
      $0.text = sections[section].type.footer
      $0.font = UIFont.thtCaption1R
      $0.textColor = DSKitAsset.Color.neutral300.color
      $0.numberOfLines = 2
    }

    header.addSubview(label)

    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(5)
      $0.bottom.equalToSuperview().offset(-5)
    }

    return header
  }
}

extension MySettingView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let section = sections[indexPath.section]
    let item = section.items[indexPath.item]
    if section.type == .banner {
      let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BannerCell.self)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MyPageDefaultTableViewCell.self)
      cell.bind(type: section.type, item: item)
      return cell
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].items.count
  }
}

fileprivate class BannerCell: TFBaseTableViewCell {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .thtP1B
    label.textColor = DSKitAsset.Color.neutral50.color
    label.text = "대화에 빠져드는 시간"
    return label
  }()

  private let titleVStack = UIStackView().then {
    $0.spacing = 10.adjustedH
    $0.axis = .vertical
    $0.alignment = .leading
  }

  private let rightBannerImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Component.bannerImage.image
  }
  private let logoImageView = UIImageView().then {
    $0.image = DSKitAsset.Image.Component.fallingLogo.image
  }

  private var gradientLayer: CAGradientLayer?

  override func layoutSubviews() {
    gradientLayer?.frame = self.bounds
  }

  private func makeGradient() -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      DSKitAsset.Color.linear0.color.cgColor,
      DSKitAsset.Color.linear1.color.cgColor,
      DSKitAsset.Color.linear2.color.cgColor,
    ]
    gradientLayer.locations = [0, 0.51, 1]
    let angle: CGFloat = -79

    let height = -sin(angle * .pi / 180)

    gradientLayer.startPoint = CGPointMake(0,0.5 + height)
    gradientLayer.endPoint = CGPointMake(1, 0.5)
    return gradientLayer
  }

  override func makeUI() {
    if gradientLayer == nil {
      let layer = makeGradient()
      self.gradientLayer = layer
      self.contentView.layer.addSublayer(layer)
    }
    contentView.addSubviews(titleVStack, rightBannerImageView)
    titleVStack.addArrangedSubviews([titleLabel, logoImageView])

    rightBannerImageView.snp.makeConstraints {
      $0.top.bottom.trailing.equalToSuperview()
    }

    titleVStack.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(rightBannerImageView.snp.leading).offset(-21.adjusted)
    }
  }
}
