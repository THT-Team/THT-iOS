//
//  SignUpCompleteViewModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 5/28/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa

import SignUpInterface
import AuthInterface
import Domain

final class SignUpCompleteViewModel: BasePenddingViewModel, ViewModelType {
  private let contacts: [ContactType]

  required init(useCase: SignUpUseCaseInterface, pendingUser: PendingUser, contacts: [ContactType]) {
    self.contacts = contacts
    super.init(useCase: useCase, pendingUser: pendingUser)
  }

  var onNext: (() -> Void)?

  struct Input {
    let nextBtnTap: Driver<Void>
  }

  struct Output {
    let loadTrigger: Driver<Bool>
    let toast: Signal<String>
    let profileImage: Driver<Data?>
  }

  func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()
    let loadTrigger = PublishRelay<Bool>()

    let user = Driver.just(self.pendingUser)

    let imagesData = user
      .asObservable()
      .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
      .withUnretained(self)
      .flatMapLatest { (ref, user) -> Observable<[Data]> in
        ref.useCase.fetchUserPhotos(key: user.phoneNumber, fileNames: user.photos)
          .asObservable()
          .catch { error in
            toast.accept("사진을 불러오는데 실패했습니다.")
            return .empty()
          }
      }.asDriverOnErrorJustEmpty()

    input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(imagesData)
      .asObservable()
      .withUnretained(self)
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
      .flatMapLatest { owner, data in
        owner.useCase.signUp(owner.pendingUser, imageData: data, contacts: owner.contacts)
          .asObservable()
          .catch { error in
            toast.accept(error.localizedDescription)
            return .empty()
          }
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, _ in
        owner.onNext?()
      }
      .disposed(by: disposeBag)

    return Output(
      loadTrigger: loadTrigger.asDriverOnErrorJustEmpty(),
      toast: toast.asSignal(onErrorSignalWith: .empty()),
      profileImage: imagesData.map { $0.first }
    )
  }
}
