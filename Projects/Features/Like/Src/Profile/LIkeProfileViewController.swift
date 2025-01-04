//
//  LIkeProfileViewController.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//


import UIKit

import DSKit

import LikeInterface
import Domain

final class LikeProfileViewController: TFBaseViewController {
  private lazy var mainView = ProfileView()

  private let viewModel: LikeProfileViewModel
  private var dataSource: UICollectionViewDiffableDataSource<ProfilePhotoSection, UserProfilePhoto>!
  private let reportRelay = PublishRelay<Void>()
  private var info: UserInfo?

  init(viewModel: LikeProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {
    setupDataSource()

    let input = LikeProfileViewModel.Input(
      trigger: self.rx.viewWillAppear.asSignal().map { _ in },
      rejectTrigger: mainView.nextTimeButton.rx.tap.asSignal(),
      likeTrigger: mainView.chatButton.rx.tap.asSignal(),
      closeTrigger: mainView.topicBarView.closeButton.rx.tap.asSignal()
    )
    let output = viewModel.transform(input: input)

    output.topic.drive(onNext: { [weak self] topic in
      self?.mainView.topicBarView.bind(topic)
    })
    .disposed(by: disposeBag)

    output.userInfo
      .do(onNext: { [weak self] info in
        self?.info = info
      })
      .map {
        $0.userProfilePhotos
      }.drive(onNext: {[weak self] items in
        self?.performQuery(with: items)
      })
      .disposed(by: disposeBag)

  }
  func setupDataSource() {
    let cellRegistration = UICollectionView.CellRegistration
    <ProfileCollectionViewCell, UserProfilePhoto> { (cell, indexPath, item) in
      cell.bind(imageURL: item.url)
    }

    let footerRegistration = UICollectionView.SupplementaryRegistration
    <LikeProfileInfoReusableView>(elementKind: UICollectionView.elementKindSectionFooter) {
      [weak self] (supplementaryView, string, indexPath) in
      guard let item = self?.info else {
        return
      }
      supplementaryView.tagCollectionView.reportButton.rx.tap.asDriver()
        .drive(onNext: { [weak self] in
          self?.reportRelay.accept(Void())
        })
        .disposed(by: supplementaryView.disposeBag)

      supplementaryView.bind(viewModel: item)
    }

    dataSource = DataSource(collectionView: mainView.profileCollectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: UserProfilePhoto) -> UICollectionViewCell? in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
    }
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      view.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
    }
  }

  /// - Tag: MountainsPerformQuery
  func performQuery(with items: [UserProfilePhoto]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension LikeProfileViewController {
  typealias Snapshot = NSDiffableDataSourceSnapshot<ProfilePhotoSection, UserProfilePhoto>
  typealias DataSource = UICollectionViewDiffableDataSource<ProfilePhotoSection, UserProfilePhoto>
}

enum ProfilePhotoSection: CaseIterable {
  case main
}

