//
//  WithdrawalDetailViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import UIKit

import DSKit
import Core

import RxSwift
import RxCocoa

import Domain

final class WithdrawalDetailViewController: TFVC<WithdrawalDetailViewModel, WithdrawalDetailView> {
  typealias ViewModel = WithdrawalDetailViewModel
  typealias CellType = WithdrawalDetailCollectionViewCell

  private var dataSource: [ReasonModel] = [] {
    didSet {
      DispatchQueue.main.async { [self] in
        mainView.collectionView.reloadData()
      }
    }
  }

  override func navigationSetting() {
    super.navigationSetting()
    self.title = "계정 탈퇴"
    self.navigationController?.setNavigationBarHidden(false, animated: true)
  }

  private let otherTextRelay = PublishRelay<String>()

  override func bind(_ viewModel: ViewModel) {

    mainView.collectionView.dataSource = self

    mainView.collectionView.rx.itemSelected
      .asDriver()
      .drive(with: self) {
        $0.mainView.collectionView.deselectItem(at: $1, animated: true)
      }
      .disposed(by: disposeBag)

    let input = ViewModel.Input(
      load: self.rx.viewDidLoad.asDriver(),
      selectedIndexPath: self.mainView.collectionView.rx.itemSelected.asSignal(),
      withdrawalTap: self.mainView.withdrawalButton.rx.tap.asSignal(),
      otherText: otherTextRelay.asDriver(onErrorJustReturn: "")
    )

    let output = viewModel.transform(input: input)

    output.models
      .drive(with: self) { owner, models in
        owner.dataSource = models
      }.disposed(by: disposeBag)
  }
}

extension WithdrawalDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellType.reuseIdentifier, for: indexPath) as? CellType else {
      fatalError("Failed to dequeue cell")
    }
    let item = dataSource[indexPath.item]
    cell.bind(item)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderDescriptionView.reuseIdentifier, for: indexPath) as? HeaderDescriptionView
      header?.bind(title: self.viewModel?.withdrawalDetail.title, subTitle:  self.viewModel?.withdrawalDetail.description)
      header?.setNeedsDisplay()
      return header ?? UICollectionReusableView()
    case UICollectionView.elementKindSectionFooter:
      guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TFHeaderField.reuseIdentifier, for: indexPath) as? TFHeaderField else {
        fatalError("Failed to dequeue footer")
      }
      footer.rx.text.bind(to: otherTextRelay)
        .disposed(by: disposeBag)
      return footer
    default:
      return UICollectionReusableView()
    }
  }
}
