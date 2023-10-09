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
  private lazy var mainView = ProfileView()

  private let viewModel: HeartProfileViewModel
  private var dataSource: UICollectionViewDiffableDataSource<ProfilePhotoSection, ProfilePhotoDomain>!
  private var info: HeartUserResponse!
  private let reportRelay = PublishRelay<Void>()
  init(viewModel: HeartProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func loadView() {
    self.view = mainView
  }

  override func makeUI() {
    self.view.backgroundColor = .clear
  }

  override func bindViewModel() {
    configureDataSource()

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

    let input = HeartProfileViewModel.Input(
      trigger: self.rx.viewWillAppear.asDriver().map { _ in },
      rejectTrigger: mainView.nextTimeButton.rx.tap.asDriver(),
      chatRoomTrigger: mainView.chatButton.rx.tap.asDriver(),
      closeTrigger: mainView.topicBarView.closeButton.rx.tap.asDriver(),
      reportTrigger: reportTrigger
    )
    let output = viewModel.transform(input: input)
    output.topic.drive(onNext: { [weak self] topic in
      self?.mainView.topicBarView.configure(topic)
    }).disposed(by: disposeBag
    )
    output.userInfo
      .map {
        $0.userProfilePhotos
          .map { $0.toDomain() }
      }.drive(onNext: {[weak self] items in
        self?.performQuery(with: items)
      })
      .disposed(by: disposeBag)
    output.userInfo
      .drive(onNext: { [weak self] info in
        self?.info = info
      }).disposed(by: disposeBag)
    //
    output.navigate.drive()
      .disposed(by: disposeBag)
  }
  func configureDataSource() {
    let cellRegistration = UICollectionView.CellRegistration
    <ProfileCollectionViewCell, ProfilePhotoDomain> { (cell, indexPath, item) in
      // Populate the cell with our item description.
      cell.configure(imageURL: item.url)
    }
    //
    let footerRegistration = UICollectionView.SupplementaryRegistration
    <ProfileInfoReusableView>(elementKind: UICollectionView.elementKindSectionFooter) {
      (supplementaryView, string, indexPath) in
      guard let item = self.info else {
        return
      }
      supplementaryView.reportButton.rx.tap.asDriver()
        .drive(onNext: { [weak self] in
          self?.reportRelay.accept(Void())
        })
        .disposed(by: supplementaryView.disposeBag)
      supplementaryView.configure(info: item)
    }


    dataSource = UICollectionViewDiffableDataSource<ProfilePhotoSection, ProfilePhotoDomain>(collectionView: mainView.profileCollectionView) {
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
    var snapshot = NSDiffableDataSourceSnapshot<ProfilePhotoSection, ProfilePhotoDomain>()
    snapshot.appendSections([.main])
    snapshot.appendItems(items)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

#if DEBUG
import SwiftUI

struct profileviewPreview: PreviewProvider {
  static var previews: some View {
    let service = HeartAPI(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil)
    let viewModel = HeartProfileViewModel(
      service: service,
      navigator: MockProfileNavigator(),
      likeItem: .mock)
    let vc = ProfileViewController(viewModel: viewModel)
    return vc.toPreView()
  }
}
#endif
