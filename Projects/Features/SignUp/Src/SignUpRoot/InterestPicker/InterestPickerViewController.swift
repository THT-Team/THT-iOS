//
//  InterestPickerViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import UIKit
import PhotosUI

import DSKit

import RxSwift
import RxCocoa

final class InterestPickerViewController: TFBaseViewController {
  typealias VMType = InterestTagPickerViewModel
  private(set) var mainView = InterestTagPickerView()
  private let viewModel: VMType

  init(viewModel: VMType) {
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

    let nextBtnTap = mainView.nextBtn.rx.tap.asDriver()

    let input = VMType.Input(
      chipTap: mainView.collectionView.rx.itemSelected.asDriver(),
      nextBtnTap: nextBtnTap
    )

    let output = viewModel.transform(input: input)

    output.chips
      .drive(mainView.collectionView.rx.items(cellIdentifier: TagCollectionViewCell.reuseIdentifier, cellType: TagCollectionViewCell.self)) { index, item, cell in

        cell.contentView.layer.borderColor = DSKitAsset.Color.neutral300.color.cgColor
        cell.contentView.layer.borderWidth = 1
        cell.bind(TagItemViewModel(emojiCode: item.emojiCode, title: item.name))
      }
      .disposed(by: disposeBag)

    output.isNextBtnEnabled
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)
  }
}
