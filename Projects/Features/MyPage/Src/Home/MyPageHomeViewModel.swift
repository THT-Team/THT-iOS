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

public final class MyPageHomeViewModel: ViewModelType {
  private let myPageUseCase: MyPageUseCaseInterface

  // MARK: Coordinating
  var onSetting: ((User) -> Void)?
  var onPhotoEdit: ((TopBottomAlertHandler) -> Void)?
  var onPhotoCell: ((Int, PhotoPickerHandler?) -> Void)?
  var onEditInfo: ((MyPageSection) -> Void)?
  var onEditNickname: ((String) -> Void)?

  public struct Input {
    let delegateAction: Driver<MyPageHome.Action>
  }

  public struct Output {
    let user: Driver<[MyPageInfoCollectionViewCellViewModel]>
    let headerModel: Driver<PhotoHeaderModel>
    let toast: Signal<String>
    let isDimHidden: Signal<Bool>
  }

  private var disposeBag = DisposeBag()
  private let userStore: UserStore

  public init(myPageUseCase: MyPageUseCaseInterface, userStore: UserStore) {
    self.myPageUseCase = myPageUseCase
    self.userStore = userStore
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func transform(input: Input) -> Output {
    let isDimHiddenTrigger = PublishRelay<Bool>()
    let selectedIndex = PublishRelay<Int>()
    let photoEditTrigger = PublishRelay<Int>()
    let photoAlertTrigger = PublishRelay<TopBottomAction>()
    let selectedPHResult = PublishRelay<PhotoItem>()

    userStore.send(action: .fetch)

    let user = userStore.binding.asDriverOnErrorJustEmpty()
      .compactMap { $0 }

    let output = user.map { UserInfoMapper.map($0) }

    let photos = user.map(\.userProfilePhotos)

    input.delegateAction.filter {
      if case .settingTap = $0 {
        return true
      }
      return false
    }
    .withLatestFrom(user)
    .drive(with: self) { owner, user in
      owner.onSetting?(user)
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
        owner.onPhotoEdit? { action in
          photoAlertTrigger.accept(action)
        }
      }.disposed(by: disposeBag)

    photoEditTrigger.asSignal()
      .emit(with: self) { owner, index in
        let handler: (PhotoPickerHandler)? = { item in
          selectedPHResult.accept(item)
        }
        selectedIndex.accept(index)
        owner.onPhotoCell?(index, handler)
      }.disposed(by: disposeBag)

    input.delegateAction
      .withLatestFrom(output) { action, array -> MyPageInfoCollectionViewCellViewModel? in
        if case let .sectionTap(index) = action {
          return array[index]
        }
        return nil
      }
      .compactMap { $0 }
      .drive(with: self, onNext: { owner, viewModel in
        owner.onEditInfo?(viewModel.model)
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
        owner.onEditNickname?(nickname)
      }.disposed(by: disposeBag)

    photoAlertTrigger.asSignal()
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

    selectedPHResult
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, result -> Observable<Data> in
        owner.myPageUseCase.processImage(result)
          .asObservable()
      }
      .withLatestFrom(selectedIndex) { ($0, $1) }
      .withUnretained(self) { ($0, $1.0, $1.1) }
      .flatMapLatest { owner, data, index -> Observable<UserProfilePhoto> in
        owner.myPageUseCase.updateImage(data, priority: index + 1)
          .asObservable()
      }
      .withLatestFrom(photos) { photo, array -> [UserProfilePhoto] in
        var mutable = array
        if let index = mutable.firstIndex(where: { photo.priority == $0.priority }) {
          mutable[index] = photo
        } else {
          mutable.append(photo)
        }
        return mutable
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self, onNext: { owner, values in
        owner.userStore.send(action: .photos(values))
      })
      .disposed(by: disposeBag)

    let headerModel = user
      .map { user -> PhotoHeaderModel in
        var array = Array.init(repeating: PhotoHeaderCellViewModel(cellType: .optional), count: 3)

        user.userProfilePhotos.enumerated()
          .forEach { index, photo in
          array[index] = PhotoHeaderCellViewModel(
            url: URL(string: photo.url),
            cellType: photo.priority < 3 ? .required : .optional)
        }

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

struct UserInfoMapper {
  static func map(_ user: User) -> [MyPageInfoCollectionViewCellViewModel] {
    return [
      .init(model: .birthday( user.birthday)),
      .init(model: .gender(user.gender)),
      .init(model: .introduction(user.introduction)),
      .init(model: .preferGender(user.preferGender)),
      .init(model: .height(user.tall)),
      .init(model: .smoking(user.smoking)),
      .init(model: .drinking(user.drinking)),
      .init(model: .religion(user.religion)),
      .init(model: .interest(user.interestsList)),
      .init(model: .idealType(user.idealTypeList))
    ]
  }
}
