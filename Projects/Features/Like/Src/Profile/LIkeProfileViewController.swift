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
import RxSwift
import RxCocoa

final class LikeProfileViewController: TFBaseViewController {
  private lazy var mainView = ProfileView()

  private let viewModel: LikeProfileViewModel
  private let reportRelay = PublishRelay<Void>()
  private let sectionsRelay = BehaviorRelay<[ProfileDetailSection]>(value: [])

  init(viewModel: LikeProfileViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {
    self.mainView.profileCollectionView.dataSource = self

    let input = LikeProfileViewModel.Input(
      trigger: self.rx.viewWillAppear.asSignal().map { _ in },
      rejectTrigger: mainView.nextTimeButton.rx.tap.asSignal(),
      likeTrigger: mainView.chatButton.rx.tap.asSignal(),
      closeTrigger: mainView.topicBarView.closeButton.rx.tap.asSignal(),
      reportTrigger: reportRelay.asSignal()
    )
    let output = viewModel.transform(input: input)

    output.topic.drive(onNext: { [weak self] topic in
      self?.mainView.topicBarView.bind(topic)
    })
    .disposed(by: disposeBag)

    output.sections
      .drive(sectionsRelay)
      .disposed(by: disposeBag)

    output.isBlurHidden
      .drive(mainView.visualEffectView.rx.isHidden)
      .disposed(by: disposeBag)
  }
}

extension LikeProfileViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    sectionsRelay.value.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    sectionsRelay.value[section].count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch sectionsRelay.value[indexPath.section] {
    case let .photo(items):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileCollectionViewCell.self)
      cell.bind(imageURL: items[indexPath.item].url)
      return cell
    case let .emoji(_, items, _):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TagCollectionViewCell.self)
      let tag = items[indexPath.item]
      cell.bind(TagItemViewModel(emojiCode: tag.emojiCode, title: tag.name))
      return cell
    case let .blocks(items):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: InfoCVCell.self)
      let (title, content) = items[indexPath.item]
      cell.bind(title, content)
      return cell
    case let .text(_, content):
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ProfileIntroduceCell.self)
      cell.bind(content)
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if
      indexPath.section == 1,
      case let .emoji(sectionName, _, title) = sectionsRelay.value[indexPath.section] {
      let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: ProfileInfoReusableView.self)
      header.reportButton.rx.tap.asSignal()
        .emit(to: reportRelay)
        .disposed(by: header.disposeBag)
      header.bind(title: title?.0, subtitle: title?.1, header: sectionName)
      return header
    }
    let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
    header.title = self.sectionsRelay.value[indexPath.section].sectionTitle
    return header
  }
}
