//
//  TFBaseEmojiEditVC.swift
//  MyPage
//
//  Created by kangho lee on 7/24/24.
//

import UIKit
import DSKit

import RxSwift
import RxCocoa
import MyPageInterface
import Domain

public struct AttributedTitleInfo {
  public let title: String
  public let targetText: String

  public init(title: String, targetText: String) {
    self.title = title
    self.targetText = targetText
  }
}

open class BaseEmojiEditVC<ViewModel: CVEmojiPickerVMType>: TFBaseViewController {
  typealias CellType = InputTagCollectionViewCell
  typealias ViewModel = TFBaseEmojiEditVM
  public let viewModel: ViewModel

  public var titleModel: AttributedTitleInfo {
    fatalError()
  }

  private lazy var mainView = TagPickerEditView(title: titleModel.title, targetString: titleModel.targetText)

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  open override func loadView() {
    self.view = mainView
  }

  open override func makeUI() {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  open override func bindViewModel() {
    let itemSelected = mainView.collectionView.rx.itemSelected.asDriver().map { $0.item }
    let btnTap = mainView.nextBtn.rx.tap.asSignal()

    let input = ViewModel.Input(
      selectedItem: itemSelected,
      btnTap: btnTap
    )
    let output = viewModel.transform(input: input)
    
    output.items.drive(mainView.collectionView.rx.items(cellType: CellType.self)) { index, item, cell in
      cell.bind(item)
    }.disposed(by: disposeBag)
    
    output.isBtnEnabled
      .drive(mainView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}
