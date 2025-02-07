//
//  BaseCollectionViewVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import UIKit

import DSKit

import RxSwift
import RxCocoa
import SignUpInterface
import Domain

public protocol TFCellSizeCalculable {
  func cellSize(width: CGFloat, spacing: CGFloat) -> CGSize
}

public protocol CVInputType {
  var selectedItem: Driver<Int> { get }
  var btnTap: Signal<Void> { get }
  init(selectedItem: Driver<Int>, btnTap: Signal<Void>)
}

public protocol CVOutputType {
  associatedtype ModelType: RawRepresentable & CaseIterable & TFTitlePropertyType where ModelType.RawValue == String
  associatedtype ItemVM: TFSimpleItemType
  var items: Driver<[ItemVM]> { get }
  var isBtnEnabled: Driver<Bool> { get }
}

public protocol CVViewModelType: ViewModelType where Input: CVInputType, Output: CVOutputType { }

public protocol textBindable {
  func bind(_ text: String)
}

public protocol TFSimpleItemType {
  associatedtype ModelType: RawRepresentable & CaseIterable & TFTitlePropertyType where ModelType.RawValue == String
  var value: ModelType { get }
  var isSelected: Bool { get set }
  init(value: ModelType, isSelected: Bool)
}

public struct TFSimpleItemVM<ModelType: RawRepresentable & CaseIterable & TFTitlePropertyType>: TFSimpleItemType where ModelType.RawValue == String {
  public var value: ModelType
  public var isSelected: Bool
  public init(value: ModelType, isSelected: Bool) {
    self.value = value
    self.isSelected = isSelected
  }
}

open class TFBaseCollectionViewVC<ViewModel, CellType>: TFBaseViewController, TFCellSizeCalculable, UICollectionViewDelegateFlowLayout where ViewModel: CVViewModelType, CellType: TFBaseCollectionViewCell & textBindable & SelectableCellType {
  typealias CellType = TFSelectableCVCell
  typealias ViewModel = ViewModel
  public let viewModel: ViewModel
  
  open var titleLabel: UILabel {
    fatalError("titleLabel is not implemented")
  }

  open func createLayout() -> UICollectionViewFlowLayout {
    UICollectionViewFlowLayout()
      .then {
        $0.minimumInteritemSpacing = 16.adjusted
        $0.minimumLineSpacing = 16.adjusted
      }
  }
  open lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: createLayout()
  ).then {
    $0.register(cellType: CellType.self)
    $0.backgroundColor = .clear
    $0.showsHorizontalScrollIndicator = false
    $0.showsVerticalScrollIndicator = false
    $0.isScrollEnabled = false
    $0.delegate = self
    
    $0.delaysContentTouches = false
    $0.canCancelContentTouches = true
  }
  
  lazy var nextBtn = CTAButton(btnTitle: "수정하기", initialStatus: false)

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  open override func makeUI() {
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = DSKitAsset.Color.neutral600.color
    self.view.addSubviews(titleLabel, collectionView, nextBtn)
    let spacer = UIView()
    view.addSubview(spacer)
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32.adjustedH)
      $0.leading.trailing.equalToSuperview().inset(33.adjusted)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(24.adjustedH)
      $0.leading.trailing.equalTo(titleLabel)
      $0.height.greaterThanOrEqualTo(50.adjustedH) //.priority(.high)
    }
    
    nextBtn.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(40.adjustedH) //.priority(.low)
      $0.leading.trailing.equalTo(titleLabel).inset(5.adjusted)
      $0.bottom.equalTo(spacer.snp.top)
      $0.height.equalTo(54.adjustedH)
    }

    spacer.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.greaterThanOrEqualTo(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-24.adjustedH)
    }
  }
  
  open override func bindViewModel() {
    let itemSelected = collectionView.rx.itemSelected.asDriver().map { $0.item }
    let btnTap = nextBtn.rx.tap.asSignal()
    
    let input = ViewModel.Input(
      selectedItem: itemSelected,
      btnTap: btnTap
    )
    let output = viewModel.transform(input: input)
    
    output.items.drive(collectionView.rx.items(cellType: CellType.self)) { index, item, cell in
      cell.bind(item.value.title)
      cell.updateCell(item.isSelected)
    }.disposed(by: disposeBag)
    
    output.isBtnEnabled
      .drive(nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
  
  open func cellSize(width: CGFloat, spacing: CGFloat) -> CGSize {
    let numberOfCellsInLine: CGFloat = 3
    let cellWidth = (width - spacing * (numberOfCellsInLine - 1)) / numberOfCellsInLine - 10
    return CGSize(width: cellWidth, height: 49.adjustedH)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    cellSize(width: collectionView.frame.width, spacing: (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0)
  }
}
