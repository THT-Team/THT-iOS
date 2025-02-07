//
//  TFBaseCollectionVM.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/23/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa

import DSKit
import MyPageInterface

public protocol ProcessUseCaseProtocol {
  associatedtype ModelType: RawRepresentable & CaseIterable where ModelType.RawValue == String
  func processUseCase(value: ModelType) -> Driver<ModelType>
  func sendUserStore(item: ModelType)
}

open class TFBaseCollectionVM<ModelType, ItemVMType>: CVViewModelType, ProcessUseCaseProtocol, BottomSheetViewModelType where ModelType: RawRepresentable & CaseIterable, ModelType.RawValue == String, ItemVMType: TFSimpleItemType, ModelType == ItemVMType.ModelType {

  public struct Input: CVInputType {
    public let selectedItem: Driver<Int>
    public let btnTap: Signal<Void>
    public init(selectedItem: Driver<Int>, btnTap: Signal<Void>) {
      self.selectedItem = selectedItem
      self.btnTap = btnTap
    }
  }

  public struct Output: CVOutputType {
    public let items: Driver<[ItemVMType]>
    public let isBtnEnabled: Driver<Bool>
  }

  private var disposeBag = DisposeBag()
  private let initialValue: BottomSheetValueType
  public let useCase: MyPageUseCaseInterface
  public let userStore: UserStore
  public var onDismiss: (() -> Void)?
  public var handler: BottomSheetHandler?

  public init(
    initialValue: BottomSheetValueType,
    useCase: MyPageUseCaseInterface,
    userStore: UserStore
  ) {
    self.initialValue = initialValue
    self.useCase = useCase
    self.userStore = userStore
  }

  public func transform(input: Input) -> Output {
    let range: ModelType.AllCases = ModelType.allCases
    let defaultValue: ModelType = range[range.startIndex]
    let initialValue: Driver<ModelType> = Driver.just(self.initialValue)
      .compactMap {
        if case let .text(value) = $0 {
          return ModelType(rawValue: value) ?? defaultValue
        }
        return nil
      }
    let vms = range.map { ItemVMType(value: $0, isSelected: false) }
    let items: Driver<[ItemVMType]> = Driver<[ItemVMType]>.just(vms)
    let snapshot = BehaviorRelay<[ItemVMType]>(value: range.map { ItemVMType(value: $0, isSelected: false) })
    
    let selectedItem: Driver<ItemVMType> = input.selectedItem
      .withLatestFrom(items) { index, array in
        array[index]
      }
    let initialValueIndex = initialValue
      .withLatestFrom(items) { value, array in
        array.firstIndex(where: { $0.value == value }) ?? 0
      }
    
    Driver.merge(input.selectedItem, initialValueIndex)
      .withLatestFrom(snapshot.asDriver()) { index, array in
        var mutable: [ItemVMType] = array
        mutable.enumerated().forEach { i, item in
          mutable[i].isSelected = i == index
        }
        return mutable
      }.drive(snapshot)
      .disposed(by: disposeBag)
    
    let isBtnEnabled = Driver.combineLatest(initialValue, selectedItem.map(\.value)) { $0 != $1 }
    
    input.btnTap
      .asDriver(onErrorDriveWith: .empty())
      .withLatestFrom(isBtnEnabled)
      .filter { $0 }
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(selectedItem.map(\.value))
      .flatMapLatest { [unowned self] value in
        processUseCase(value: value)
      }
      .drive(with: self) { owner, value in
        owner.onDismiss?()
        owner.handler?(.text(text: "\(value.rawValue)"))
        owner.sendUserStore(item: value)
      }
      .disposed(by: disposeBag)

    return Output(
      items: snapshot.asDriver(),
      isBtnEnabled: isBtnEnabled
    )
  }
  
  public func processUseCase(value: ModelType) -> Driver<ModelType> {
    fatalError()
  }

  public func sendUserStore(item: ModelType) {
    fatalError()
  }
}
