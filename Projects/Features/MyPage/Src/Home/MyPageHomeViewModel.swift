//
//  MyPageHomeViewModel.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Core
import MyPageInterface
import RxSwift
import RxCocoa
import Domain
import DSKit
import PhotosUI

final class MyPageHomeViewModel: ViewModelType {
  private let myPageUseCase: MyPageUseCaseInterface
  private let selectedPHResult =  PublishRelay<PHPickerResult>()
  var pickerDelegate: PhotoPickerDelegate?

  struct Input {
    let delegateAction: Driver<MyPageHome.Action>
  }

  struct Output {
    let user: Driver<[MyPageInfoCollectionViewCellViewModel]>
    let headerModel: Driver<PhotoHeaderModel>
    let toast: Signal<String>
    let isDimHidden: Signal<Bool>
  }

  weak var delegate: MyPageCoordinatingActionDelegate?
  private var disposeBag = DisposeBag()
  private let userStore: UserStore
  private let alertSignal = PublishRelay<TopBottomAction>()

  init(myPageUseCase: MyPageUseCaseInterface, userStore: UserStore) {
    self.myPageUseCase = myPageUseCase
    self.userStore = userStore
  }

  func transform(input: Input) -> Output {
    let isDimHiddenTrigger = PublishRelay<Bool>()
    let selectedIndex = PublishRelay<Int>()
    let photoEditTrigger = PublishRelay<Int>()

    userStore.send(action: .fetch)

    let user = userStore.binding.asDriverOnErrorJustEmpty()
      .compactMap { $0 }

    let output = user.map { [weak self] user -> [MyPageInfoCollectionViewCellViewModel] in
      guard let listener = self else { return [] }
      return [
        .init(model: .birthday( user.birthday)),
        .init(model: .gender(user.gender)),
        .init(model: .introduction(user.introduction)),
        .init(model: .preferGender(user.preferGender, listener)),
        .init(model: .height(user.tall, listener)),
        .init(model: .smoking(user.smoking, listener)),
        .init(model: .drinking(user.drinking, listener)),
        .init(model: .religion(user.religion, listener)),
        .init(model: .interest(user.interestsList, listener)),
        .init(model: .idealType(user.idealTypeList, listener))
      ]
    }
    let photos = user.map(\.userProfilePhotos)

    input.delegateAction.filter {
      if case .settingTap = $0 {
        return true
      }
      return false
    }
    .withLatestFrom(user)
    .drive(with: self) { owner, user in
      owner.delegate?.invoke(.setting(user))
    }.disposed(by: disposeBag)


    let index = input.delegateAction.compactMap { action -> Int? in
      if case .photoEdit(let index) = action { return index }
      return nil
    }.asObservable()

    index.filter { $0 < 2 }
      .bind(to: photoEditTrigger)
      .disposed(by: disposeBag)

    index.filter { $0 == 2 }
      .withLatestFrom(photos) { $1.count < 3 ? true : $1[$0].url.isEmpty }
      .subscribe(with: self) { owner, isEmpty in
        if isEmpty {
          photoEditTrigger.accept(2)
          return
        }
        isDimHiddenTrigger.accept(false)
        owner.delegate?.invoke(.photoEditOrDeleteAlert(owner))
      }.disposed(by: disposeBag)

    photoEditTrigger.asSignal()
      .emit(with: self) { owner, index in
        let pickerDelegate = PhotoPickerDelegator()
        selectedIndex.accept(index)
        pickerDelegate.listener = owner
        owner.pickerDelegate = pickerDelegate
        owner.delegate?.invoke(.photoCellTap(index: index, listener: pickerDelegate))
      }.disposed(by: disposeBag)

    input.delegateAction
      .withLatestFrom(output) { action, array in
        if case let .sectionTap(index) = action {
          return array[index]
        }
        return nil
      }
      .compactMap { $0 }
      .drive(with: self, onNext: { owner, viewModel in
        owner.delegate?.invoke(.edit(viewModel.model))
      })
      .disposed(by: disposeBag)
    input.delegateAction
      .compactMap {
        if case let .nicknameEdit(nickname) = $0 {
          return nickname
        }
        return nil
      }
      .withLatestFrom(user.map(\.username))
      .drive(with: self) { owner, nickname in
        owner.delegate?.invoke(.editNickname(nickname))
      }.disposed(by: disposeBag)

    alertSignal.asSignal()
      .compactMap { action -> Int? in
        isDimHiddenTrigger.accept(true)
        switch action {
        case .top:
          photoEditTrigger.accept(2)
          return nil
        case .bottom:
          return 2
        case .cancel:
          return nil
        }
      }
      .withLatestFrom(photos.asSignal(onErrorJustReturn: [])) { $1.dropLast() }
      .emit(with: self, onNext: { owner, values in
        owner.userStore.send(action: .photos(values))
      }).disposed(by: disposeBag)

    selectedPHResult.asSignal()
      .flatMapLatest { [weak self] result -> Signal<Data> in
        guard let self else { return .empty() }
        return self.myPageUseCase.processImage(result)
          .asSignal(onErrorSignalWith: .empty())
      }
      .withLatestFrom(selectedIndex.asSignal()) { ($0, $1) }
      .flatMapLatest { [unowned self] data, index -> Signal<UserProfilePhoto> in
        self.myPageUseCase.updateImage(data, priority: index + 1)
          .asSignal(onErrorSignalWith: .empty())
      }
      .asDriver(onErrorDriveWith: .empty())
      .withLatestFrom(photos) { photo, array -> [UserProfilePhoto] in
        var mutable = array
        if let index = mutable.firstIndex(where: { photo.priority == $0.priority }) {
          mutable[index] = photo
        } else {
          mutable.append(photo)
        }
        return mutable
      }.drive(with: self, onNext: { owner, values in
        owner.userStore.send(action: .photos(values))
      })
      .disposed(by: disposeBag)

    let headerModel = user.map { user -> PhotoHeaderModel in
      var array = Array.init(repeating: PhotoHeaderCellViewModel(cellType: .optional), count: 3)
      user.userProfilePhotos.enumerated().forEach { index, photo in
        array[index] = PhotoHeaderCellViewModel(
          url: URL(string: photo.url),
          cellType: photo.priority < 3 ? .required : .optional)}

      return PhotoHeaderModel(dataSource: array, nickname: user.username)
    }

    return Output(
      user: output,
      headerModel: headerModel,
      toast: userStore.toastSignal.asSignal(onErrorSignalWith: .empty()),
      isDimHidden: isDimHiddenTrigger.asSignal()
    )
  }
}

extension MyPageHomeViewModel: BottomSheetListener {
  func sendData(item: BottomSheetValueType) {
    print(item)
  }
}

extension MyPageHomeViewModel: PhotoPickerListener {
  func picker(didFinishPicking results: [PHPickerResult]) {
    if let item = results.first {
      self.selectedPHResult.accept(item)
    }
  }
}

extension MyPageHomeViewModel: TopBottomAlertListener {
  func didTapAction(_ action: Core.TopBottomAction) {
    self.alertSignal.accept(action)
  }
}
