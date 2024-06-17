//
//  MyPageView.swift
//  MyPage
//
//  Created by Kanghos on 6/6/24.
//

import UIKit

import DSKit

import SnapKit
import Then
import Domain

protocol MyPageViewDelegate: AnyObject {
  func didTapPhotoEditButton(_ index: Int)
  func didTapPhotoAddButton(_ index: Int)
  func didTapNicknameEditButton()
}

final class MyPageView: TFBaseView {
  weak var delegate: MyPageViewDelegate?

  private(set) lazy var settingButton = UIButton().then {
    $0.setTitle("설정 관리", for: .normal)
    $0.layer.cornerRadius = 16
    $0.backgroundColor = DSKitAsset.Color.neutral600.color
    $0.clipsToBounds = true
    $0.titleLabel?.font = .thtCaption1Sb
    $0.frame.size = CGSize(width: 80, height: 32)
  }
  private(set) lazy var rightBarBtn = UIBarButtonItem(customView: settingButton)

  var dataSource: [MyPageInfoCollectionViewCellViewModel] = [ ] {
    didSet {
      DispatchQueue.main.async {
        self.infoCollectionView.reloadData()
      }
    }
  }

  var photos: [UserProfilePhoto] = [] {
    didSet {
      DispatchQueue.main.async {
        self.infoCollectionView.reloadData()
      }
    }
  }

  private(set) lazy var infoCollectionView: UICollectionView = {
    let layout = createLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

    collectionView.register(cellType: MyPageInfoCollectionViewCell.self)
    collectionView.register(cellType: MyPageTagCollectionViewCell.self)
    collectionView.register(viewType: PhotoHeaderView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor = DSKitAsset.Color.neutral600.color
    collectionView.dataSource = self
    collectionView.allowsSelection = true
    collectionView.showsVerticalScrollIndicator = false
    return collectionView
  }()

  override func makeUI() {
    addSubviews(infoCollectionView)

    infoCollectionView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.height.equalTo(400).priority(.low)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func createLayout() -> UICollectionViewLayout {
      var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    config.headerMode = .supplementary

    let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in

      var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
      config.headerMode = .supplementary
      let layoutSection =  NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
      layoutSection.interGroupSpacing = 5
      return layoutSection
    }
    return layout
  }
}

extension MyPageView {
  func bind(dataSource: [MyPageInfoCollectionViewCellViewModel]) {
    self.dataSource = dataSource
  }
}

extension MyPageView: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let viewModel = dataSource[indexPath.item]

    switch viewModel.model {
    case .interest, .idealType:
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MyPageTagCollectionViewCell.self)
      cell.bind(viewModel)
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MyPageInfoCollectionViewCell.self)
      cell.bind(viewModel)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PhotoHeaderView.reuseIdentifier, for: indexPath) as? PhotoHeaderView
    header?.bind(dataSource: self.photos.map { _ in
      .init(data: nil, cellType: .required)
    })
    header?.delegate = self
    return header ?? UICollectionReusableView()
  }
}

extension MyPageView: PhotoHeaderViewDelegate {
  func didTapPhotoEditButton(_ index: Int) {
    delegate?.didTapPhotoEditButton(index)
  }
  
  func didTapPhotoAddButton(_ index: Int) {
    delegate?.didTapPhotoAddButton(index)
  }
  
  func didTapNicknameEditButton() {
    delegate?.didTapNicknameEditButton()
  }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct MyPageViewPreview: PreviewProvider {

  static var previews: some View {
    UIViewPreview {
      return MyPageView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
