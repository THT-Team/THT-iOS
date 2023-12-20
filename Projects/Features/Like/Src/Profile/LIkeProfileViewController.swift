//
//  LIkeProfileViewController.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//


import UIKit

import Core

import SnapKit
import RxSwift
import RxCocoa

import LikeInterface

final class LikeProfileViewController: TFBaseViewController {
  private lazy var mainView = ProfileView()

  private let viewModel: LikeProfileViewModel
  private var dataSource: UICollectionViewDiffableDataSource<ProfilePhotoSection, ProfilePhotoDomain>!
  private let reportRelay = PublishRelay<Void>()
  private var info: LikeUserInfo!

  init(viewModel: LikeProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {
    setupDataSource()

    let reportTrigger = reportRelay.flatMap {
      return Observable<Void>.create { observer in

        let alert = UIAlertController(title: "Report",
                                      message: "message",
                                      preferredStyle: .actionSheet
        )
        let blockAction = UIAlertAction(title: "차단하기", style: .default, handler: { _ -> () in observer.onNext(()) })
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive, handler: { _ -> () in observer.onNext(()) })
        let noAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(blockAction)
        alert.addAction(reportAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
        return Disposables.create()
      }
    }.asDriverOnErrorJustEmpty()

    let input = LikeProfileViewModel.Input(
      trigger: self.rx.viewWillAppear.asDriver().map { _ in },
      rejectTrigger: mainView.nextTimeButton.rx.tap.asDriver(),
      likeTrigger: mainView.chatButton.rx.tap.asDriver(),
      closeTrigger: mainView.topicBarView.closeButton.rx.tap.asDriver(),
      reportTrigger: reportTrigger
    )
    let output = viewModel.transform(input: input)
    output.topic.drive(onNext: { [weak self] topic in
      self?.mainView.topicBarView.bind(topic)
    }).disposed(by: disposeBag
    )
    output.userInfo
      .do(onNext: { [weak self] info in
        self?.info = info
      })
      .map {
        $0.userProfilePhotos
          .map { $0.toDomain() }
      }.drive(onNext: {[weak self] items in
        self?.performQuery(with: items)
      })
      .disposed(by: disposeBag)

  }
  func setupDataSource() {
    let cellRegistration = UICollectionView.CellRegistration
    <ProfileCollectionViewCell, ProfilePhotoDomain> { (cell, indexPath, item) in
      // Populate the cell with our item description.
      cell.bind(imageURL: item.url)
    }
    //
    let footerRegistration = UICollectionView.SupplementaryRegistration
    <LikeProfileInfoReusableView>(elementKind: UICollectionView.elementKindSectionFooter) {
      (supplementaryView, string, indexPath) in
      guard let item = self.info else {
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
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProfilePhotoDomain) -> UICollectionViewCell? in
      // Return the cell.
      return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
    }
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return self.mainView.profileCollectionView.dequeueConfiguredReusableSupplementary(
        using: footerRegistration, for: index)
    }
  }

  /// - Tag: MountainsPerformQuery
  func performQuery(with items: [ProfilePhotoDomain]) {
    var snapshot = Snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension LikeProfileViewController {
  typealias Snapshot = NSDiffableDataSourceSnapshot<ProfilePhotoSection, ProfilePhotoDomain>
  typealias DataSource = UICollectionViewDiffableDataSource<ProfilePhotoSection, ProfilePhotoDomain>
}


enum ProfilePhotoSection: CaseIterable {
  case main
}

