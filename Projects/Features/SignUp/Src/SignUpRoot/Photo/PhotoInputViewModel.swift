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
import SignUpInterface

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

  private let userInfoUseCase: UserInfoUseCaseInterface

  init(userInfoUseCase: UserInfoUseCaseInterface) {
    self.userInfoUseCase = userInfoUseCase
  }

  deinit {
    print("deinit: PhotoInputViewModel")
  }

  private let selectedPHResult =  PublishSubject<PHPickerResult>()
  private var disposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let imageDataArray = BehaviorRelay<[PhotoCellViewModel]>(value: [
      PhotoCellViewModel(data: nil, cellType: .required),
      PhotoCellViewModel(data: nil, cellType: .required),
      PhotoCellViewModel(data: nil, cellType: .optional)
    ])
    let userinfo = Driver.just(())
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    userinfo.map { (key: $0.phoneNumber,fileNames: $0.photos) }
      .asObservable()
      .withUnretained(self)
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
      .flatMapLatest { owner, components in
        owner.userInfoUseCase.fetchUserPhotos(key: components.key, fileNames: components.fileNames)
          .catchAndReturn([])
          .asObservable()
      }
      .debug("fetched photo fileURLs")
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
      return mutable
    }.drive(imageDataArray)
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
      .asDriver(onErrorJustReturn: false)

    input.nextBtnTap
      .withLatestFrom(nextBtnStatus)
      .filter { $0 }
      .throttle(.milliseconds(400), latest: false)
      .asObservable()
      .withLatestFrom(imageDataArray)
      .map { $0.compactMap { $0.data } }
      .withLatestFrom(userinfo) { (key: $1.phoneNumber, datas: $0) }
      .withUnretained(self)
      .flatMapLatest { owner, components  in
        owner.userInfoUseCase.saveUserPhotos(key: components.key, datas: components.datas)
          .catchAndReturn([])
          .asObservable()
      }
      .debug("saved filed URLS:")
      .withLatestFrom(userinfo) { urls, userinfo in
        var mutable = userinfo
        mutable.photos = urls
        return mutable
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtPhoto)
      }.disposed(by: disposeBag)

    return Output(
      images: imageDataArray.asDriver(),
      nextBtn: nextBtnStatus
    )
  }
}

extension PhotoInputViewModel: PhotoPickerListener {
  func picker(didFinishPicking results: [PHPickerResult]) {
    if let item = results.first {
      self.selectedPHResult.onNext(item)
    }
  }
}
