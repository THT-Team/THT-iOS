//
//  PhotoInputViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import Core

import RxSwift
import RxCocoa
import SignUpInterface
import Domain

enum PhotoAlertAction {
  case edit(IndexPath)
  case delete(IndexPath)
}

final class PhotoInputViewModel: BasePenddingViewModel, ViewModelType {
  var onFetchPhoto: ((PhotoPickerHandler?) -> Void)?
  var onPhotoEdit: ((TopBottomAlertHandler) -> Void)?
  var onNext: ((PendingUser) -> Void)?

  struct Input {
    let cellTap: Signal<Int>
    let nextBtnTap: Driver<Void>
  }

  struct Output {
    let images: Driver<[PhotoCellViewModel]>
    let nextBtn: Driver<Bool>
    let isDimHidden: Signal<Bool>
  }

  func transform(input: Input) -> Output {
    let user = Driver.just(self.pendingUser)
    let isDimHidden = PublishRelay<Bool>()
    let editTrigger = PublishRelay<Int>()

    let selectedPHResult = PublishSubject<PhotoItem>()
    let photoAlertTrigger = PublishRelay<TopBottomAction>()

    let imageDataArray = BehaviorRelay<[PhotoCellViewModel]>(value: [
      PhotoCellViewModel(data: nil, cellType: .required),
      PhotoCellViewModel(data: nil, cellType: .required),
      PhotoCellViewModel(data: nil, cellType: .optional)
    ])

    let fetchedData = user
      .asObservable()
      .withUnretained(self)
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
      .flatMapLatest { owner, user in
        owner.useCase.fetchUserPhotos(key: user.phoneNumber, fileNames: user.photos)
          .catchAndReturn([])
          .asObservable()
      }
      .debug("fetched photo fileURLs")

    fetchedData
      .withLatestFrom(imageDataArray) { dataArray, models in
        var mutable = models
        for (index, data) in dataArray.enumerated() {
          mutable[index].data = data
        }
        return mutable
      }
      .asDriverOnErrorJustEmpty()
      .drive(imageDataArray)
      .disposed(by: disposeBag)

    input.cellTap.filter { $0 < 2 }
      .emit(to: editTrigger)
      .disposed(by: disposeBag)

    input.cellTap.filter { $0 == 2 }.asObservable()
      .withLatestFrom(imageDataArray) { $1[$0].data }
      .subscribe(with: self) { owner, dataOrNil in
        if dataOrNil == nil {
          editTrigger.accept(2)
          return
        }
        isDimHidden.accept(false)
        owner.onPhotoEdit? { action in
          photoAlertTrigger.accept(action)
        }
      }.disposed(by: disposeBag)

    photoAlertTrigger.asSignal()
      .emit(onNext: {
        isDimHidden.accept(true)
        switch $0 {
        case .top:
          editTrigger.accept(2)
        case .bottom:
          var mutable = imageDataArray.value
          mutable[2].data = nil
          imageDataArray.accept(mutable)
        case .cancel:
          break
        }
      })
      .disposed(by: disposeBag)

    editTrigger.asSignal()
      .emit(with: self) { owner, index in
        let handler: PhotoPickerHandler? = { item in
          selectedPHResult.onNext(item)
        }
        owner.onFetchPhoto?(handler)
      }.disposed(by: disposeBag)

    let data = selectedPHResult
      .withUnretained(self)
      .flatMapLatest { owner, asset -> Driver<Data> in
        owner.useCase.processImage(asset)
          .debug("image")
          .asDriver(onErrorDriveWith: .empty())
      }
      .asSignal(onErrorSignalWith: .empty())

    data
      .withLatestFrom(editTrigger.asSignal()) { data, index in
      var mutable = imageDataArray.value
      mutable[index].data = data
      return mutable
    }.emit(to: imageDataArray)
      .disposed(by: disposeBag)

    let nextBtnStatus = imageDataArray
      .map { array in
        array
          .filter { $0.cellType == .required }
          .compactMap(\.data).count > 1
      }
      .asDriver(onErrorJustReturn: false)

    input.nextBtnTap
      .withLatestFrom(nextBtnStatus)
      .filter { $0 }
      .throttle(.milliseconds(400), latest: false)
      .asObservable()
      .withLatestFrom(imageDataArray.map { $0.compactMap { $0.data }})
      .withUnretained(self)
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
      .flatMapLatest { owner, datas in
        owner.useCase.saveUserPhotos(owner.pendingUser, datas: datas)
          .asObservable()
          .catch({ error in
            print(error.localizedDescription)
            return .empty()
          })
      }
      .debug("saved filed URLS:")
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, user in
        owner.onNext?(owner.pendingUser)
      }.disposed(by: disposeBag)

    return Output(
      images: imageDataArray.asDriver(),
      nextBtn: nextBtnStatus,
      isDimHidden: isDimHidden.asSignal()
    )
  }
}
