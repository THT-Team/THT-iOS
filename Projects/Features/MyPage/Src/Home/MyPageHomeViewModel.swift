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

final class MyPageHomeViewModel: ViewModelType {
  private let myPageUseCase: MyPageUseCaseInterface
  
  struct Input {
    let viewDidload: Driver<Void>
    let delegateAction: Driver<MyPageHome.Action>
  }
  
  struct Output {
    let user: Driver<[MyPageInfoCollectionViewCellViewModel]>
    let photos: Driver<[UserProfilePhoto]>
  }

  weak var delegate: MyPageCoordinatingActionDelegate?
  private var disposeBag = DisposeBag()

  init(myPageUseCase: MyPageUseCaseInterface) {
    self.myPageUseCase = myPageUseCase
  }
  
  func transform(input: Input) -> Output {
    
    let user = input.viewDidload
      .debug("viewD")
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, _ in
        owner.myPageUseCase.fetchUser()
          .asObservable()
          .catch { error in
            return .empty()
          }
      }
      .asDriverOnErrorJustEmpty()

   let output = user.map { user -> [MyPageInfoCollectionViewCellViewModel] in
      [
        .init(model: .birthday(Date().toYMDDotDateString())),
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

    let photos = user
      .map { $0.userProfilePhotos }

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

    return Output(
      user: output,
      photos: photos
    )
  }
}
