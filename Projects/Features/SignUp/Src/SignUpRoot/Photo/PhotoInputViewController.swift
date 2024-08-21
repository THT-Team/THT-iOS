//
//  PhotoInputViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit
import PhotosUI

import DSKit

import RxSwift
import RxCocoa

final class PhotoInputViewController: BaseSignUpVC<PhotoInputViewModel>, StageProgressable {
  var stage: Float = 4

  var dataSource: DataSource!
  private(set) var mainView = PhotoInputView()

  override func loadView() {
    self.view = mainView
  }

  override func makeUI() {
    configureDataSource()
    mainView.photoCollectionView.backgroundColor = .clear
  }

  override func bindViewModel() {

    let cellSignal = mainView.photoCollectionView.rx.itemSelected.asSignal().map(\.item)
    let nextBtnTap = mainView.nextBtn.rx.tap.asDriver()

    let input = ViewModel.Input(
      cellTap: cellSignal,
      nextBtnTap: nextBtnTap
    )

    let output = viewModel.transform(input: input)

    output.images
      .drive(with: self) { owner, items in
        owner.updateSnapshot(items: items)
      }.disposed(by: disposeBag)
    output.nextBtn
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)

    output.isDimHidden
      .emit(with: self, onNext: { owner, isHidden in
        UIView.animate(withDuration: 0.3) {
          owner.mainView.blurView.alpha = isHidden ? 0 : 1
        }
      })
      .disposed(by: disposeBag)
  }
}
