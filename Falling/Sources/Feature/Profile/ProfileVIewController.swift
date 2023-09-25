//
//  ProfileVIewController.swift
//  Falling
//
//  Created by Kanghos on 2023/09/15.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileViewController: TFBaseViewController {

  private lazy var dimmedView: UIView = {
    let view = UIView()
    view.backgroundColor = .black.withAlphaComponent(0.5)
    return view
  }()

  var viewModel: HeartProfileViewModel!

  private lazy var topicBarView = TFTopicBarView()
  private var images: [UserProfilePhoto] = []
  private lazy var profileCollectionView: UICollectionView = {
    let size = NSCollectionLayoutSize(
      widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
      heightDimension: NSCollectionLayoutDimension.estimated(300)
    )
    let item = NSCollectionLayoutItem(layoutSize: size)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: size, repeatingSubitem: item, count: 1)

    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    section.interGroupSpacing = 10

    let headerFooterSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .estimated(300)
    )
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerFooterSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )
    section.boundarySupplementaryItems = [sectionHeader]
    let layout = UICollectionViewCompositionalLayout(section: section)

//    let layout = UICollectionViewFlowLayout()
//    layout.minimumLineSpacing = 10
//    let width = UIScreen.main.bounds.width
//    layout.estimatedItemSize = CGSize(width: width - 20, height: width - 20)
//    //    layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 300)
//    layout.footerReferenceSize = CGSize(width: width - 20, height: 150)

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor  = FallingAsset.Color.disabled.color
    //    collectionView.delegate = self
    collectionView.register(cellType: ProfileCollectionViewCell.self)
    collectionView.register(viewType: ProfileInfoReusableView.self, kind: UICollectionView.elementKindSectionFooter)
    collectionView.layer.cornerRadius = 12
    collectionView.clipsToBounds = true
    return collectionView
  }()

  private lazy var nextTimeButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("다음에")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = FallingAsset.Color.neutral50.color
    config.baseBackgroundColor = FallingAsset.Color.neutral500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 20
    return stackView
  }()

  private lazy var chatButton: UIButton = {
    let button = UIButton()
    var config = UIButton.Configuration.filled()

    config.cornerStyle = .capsule

    var titleAttribute = AttributedString("대화히기")
    titleAttribute.font = UIFont.thtSubTitle2Sb
    titleAttribute.foregroundColor = FallingAsset.Color.neutral700.color
    config.baseBackgroundColor = FallingAsset.Color.primary500.color
    config.attributedTitle = titleAttribute

    button.configuration = config

    return button
  }()

  override func makeUI() {
    self.view.backgroundColor = .black.withAlphaComponent(0.1)
    self.view.isOpaque = false
    [dimmedView, topicBarView, profileCollectionView, stackView].forEach {
      self.view.addSubview($0)
    }

    stackView.addArrangedSubview(nextTimeButton)
    stackView.addArrangedSubview(chatButton)

    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    topicBarView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().offset(100)
    }
    profileCollectionView.snp.makeConstraints {
      $0.top.equalTo(topicBarView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(100)
      $0.leading.trailing.equalTo(topicBarView)
    }

    stackView.snp.makeConstraints {
      $0.centerY.equalTo(profileCollectionView.snp.bottom)
      $0.leading.trailing.equalTo(profileCollectionView).inset(10)
      $0.height.equalTo(46)
    }
  }

  override func bindViewModel() {
    topicBarView.configure(title: "애완동물aa", content: "띄어쓰기 asdfasdfasd\n 띄어쓰기 ")
    topicBarView.closeButton.addTarget(self, action: #selector(closeButtonTap), for: .touchUpInside)

    let input = HeartProfileViewModel.Input(
      trigger: self.rx.viewWillAppear.asDriver().map { _ in },
      rejectTrigger: nextTimeButton.rx.tap.asDriver(),
      chatRoomTrigger: chatButton.rx.tap.asDriver()
    )
    let dataSource = RxCollectionViewSectionedReloadDataSource<ProfileSection> { dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileCollectionViewCell.self)
      cell.configure(imageURL: item.url)
      return cell
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
      let footer = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: ProfileInfoReusableView.self)
      let item = dataSource[indexPath.section].info
      footer.configure(info: item)
      return footer
    }
    let output = viewModel.transform(input: input)
    output.userInfo
      .map { [weak self] userInfo -> [ProfileSection] in
        let section = ProfileSection(items: userInfo.userProfilePhotos, info: userInfo)
        self?.images = userInfo.userProfilePhotos
        return [section]
      }.drive(profileCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    output.navigate.drive()
      .disposed(by: disposeBag)
  }
  @objc
  private func closeButtonTap(sender: UIButton) {
    self.dismiss(animated: true)
  }

  func createLayout() -> UICollectionViewLayout {
      let estimatedHeight = CGFloat(100)
      let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .estimated(estimatedHeight))
      let item = NSCollectionLayoutItem(layoutSize: layoutSize)
    let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize,
                                                 subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      section.interGroupSpacing = 10
      let layout = UICollectionViewCompositionalLayout(section: section)
      return layout
  }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {

}

struct ProfileSection {
  var items: [Item]
  let info: HeartUserResponse
}
extension ProfileSection: SectionModelType {
  typealias Item = UserProfilePhoto

  init(original: ProfileSection, items: [UserProfilePhoto]) {
    self = original
    self.items = items
  }
}
