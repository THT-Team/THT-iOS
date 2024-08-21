//
//  SelectionWithdrawViewController.swift
//  MyPage
//
//  Created by Kanghos on 7/3/24.
//

import UIKit

import DSKit
import MyPageInterface

final class SelectWithdrawViewController: TFBaseViewController {
  typealias ViewModel = SelectWithdrawalViewModel
  typealias CellType = WithdrawalCollectionViewCell

  private let mainView = SelectWithdrawalView()

  public init(viewModel: ViewModel) {
    defer { self.viewModel = viewModel }
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var viewModel: ViewModel? {
    didSet {
      if let viewModel {
        bind(viewModel)
      }
    }
  }

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {

  }

  func bind(_ viewModel: ViewModel) {
    mainView.collectionView.delegate = self

    mainView.collectionView.rx.itemSelected
      .asDriver()
      .drive(with: self) {
        $0.mainView.collectionView.deselectItem(at: $1, animated: true)
      }.disposed(by: disposeBag)

    let input = ViewModel.Input(
      load: self.rx.viewDidLoad.asDriver(),
      selectModel: self.mainView.collectionView.rx.modelSelected(WithdrawalReason.self).asDriver()
    )

    let output = viewModel.transform(input: input)

    output.models
      .drive(mainView.collectionView.rx.items(cellType: CellType.self)) { index, model, cell in
        cell.model = model
      }.disposed(by: disposeBag)
  }
}

extension SelectWithdrawViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - (12) - (16 * 2)) / 2
    let height = 123 * width / 173
    return CGSize(width: width, height: height)
  }
}
