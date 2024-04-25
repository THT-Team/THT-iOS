//
//  PhotoInputViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit
import PhotosUI

import Core

import RxSwift
import RxCocoa

enum PhotoAlertAction {
  case edit(IndexPath)
  case delete(IndexPath)
}

public protocol PhotoPickerListener: AnyObject {
  func picker(didFinishPicking results: [PHPickerResult])
}

final class PhotoInputViewModel: ViewModelType {
  weak var delegate: SignUpCoordinatingActionDelegate?
  var pickerDelegate: PhotoPickerDelegate?
  var service: PHPickerHandler = PhotoService()

  struct Input {
    let cellTap: Driver<IndexPath>
    let alertTap: Driver<PhotoAlertAction>
    let nextBtnTap: Driver<Void>
  }

  struct Output {
    let images: Driver<[PhotoCellViewModel]>
    let nextBtn: Driver<Bool>
  }

  private let selectedPHResult =  PublishSubject<PHPickerResult>()
  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let imageDataArray = BehaviorRelay<[PhotoCellViewModel]>(value: [
      PhotoCellViewModel(data: nil, cellType: .required),
      PhotoCellViewModel(data: nil, cellType: .required),
      PhotoCellViewModel(data: nil, cellType: .optional)
    ])

    let alertEditAction = input.alertTap
      .compactMap { action -> IndexPath? in
        switch action {
        case let .edit(indexPath):
          return indexPath
        case .delete:
          return nil
        }
      }

    input.alertTap
      .compactMap { action in
        if case let .delete(indexPath) = action {
          return indexPath.item
        }
        return nil
      }.drive(onNext: { item in
        var mutable = imageDataArray.value
        mutable[item].data = nil
        imageDataArray.accept(mutable)
      }).disposed(by: disposeBag)

    let index = Driver.merge(input.cellTap, alertEditAction)
      .map {
        $0.item
      }
      .do(onNext: { [weak self] index in
        guard let self = self else { return }
        let pickerDelegate = PhotoPickerDelegator()
        pickerDelegate.listener = self
        self.pickerDelegate = pickerDelegate

        self.delegate?.invoke(.photoCellTap(index: index, listener: pickerDelegate))
      })

    let data = self.selectedPHResult
      .withUnretained(self)
      .flatMapLatest { owner, asset -> Driver<Data> in
        owner.service.bind(asset)
          .debug("image")
          .asDriver(onErrorDriveWith: .empty())
      }
      .asDriverOnErrorJustEmpty()

    Driver.zip(index, data) { index, data in
      var mutable = imageDataArray.value
      mutable[index].data = data
      imageDataArray.accept(mutable)
    }.drive()
      .disposed(by: disposeBag)

    let nextBtnStatus = imageDataArray
      .map { $0.prefix(2) }
      .map { cells in
        for cell in cells {
          if cell.data == nil {
            return false
          }
        }
        return true
      }
    input.nextBtnTap
      .drive(with: self) { owner, _ in
        owner.delegate?.invoke(.nextAtPhoto([]))
      }.disposed(by: disposeBag)

    return Output(
      images: imageDataArray.asDriver(),
      nextBtn: nextBtnStatus.asDriverOnErrorJustEmpty()
    )
  }
}

extension PhotoInputViewModel: PhotoPickerListener {
  func picker(didFinishPicking results: [PHPickerResult]) {
    if let item = results.first {
      self.selectedPHResult.onNext(item)
      self.pickerDelegate = nil
    }
  }
}
