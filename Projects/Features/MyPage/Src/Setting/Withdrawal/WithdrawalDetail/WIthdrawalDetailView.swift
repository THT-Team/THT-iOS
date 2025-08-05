//
//  WIthdrawalDetailView.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import DSKit

final class WithdrawalDetailView: TFBaseView {

  lazy var collectionView: UICollectionView = {
    let cv = MyPageTagCollectionView(frame: .zero, collectionViewLayout: createLayout())

    cv.register(cellType: WithdrawalDetailCollectionViewCell.self)
    cv.register(viewType: HeaderDescriptionView.self, kind: UICollectionView.elementKindSectionHeader)
    cv.register(viewType: TFHeaderField.self, kind: UICollectionView.elementKindSectionFooter)
    return cv
  }()

  private(set) lazy var withdrawalButton = TFTextButton(title: "계정 탈퇴")

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color

    addSubviews(
      collectionView,
      withdrawalButton
    )

    collectionView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(safeAreaLayoutGuide)//.offset(20)
    }

    withdrawalButton.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom)//.offset(42)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(40)
      $0.bottom.equalToSuperview().offset(-70)
    }
  }
}

extension WithdrawalDetailView {

  private func createLayout() -> UICollectionViewLayout {
    var config = UICollectionLayoutListConfiguration(appearance: .grouped)
    config.separatorConfiguration.color = DSKitAsset.Color.neutral500.color
    config.separatorConfiguration.topSeparatorInsets = .zero
    config.separatorConfiguration.bottomSeparatorInsets = .zero
    config.backgroundColor = DSKitAsset.Color.neutral700.color
    config.headerMode = .supplementary
    config.footerMode = .supplementary

    let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in

      let layoutSection = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)

      return layoutSection
    }
    return layout
  }
}
