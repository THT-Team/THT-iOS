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

final class SignUpCompleteViewModel: ViewModelType {
  private let useCase: SignUpUseCaseInterface
  private let userInfoUseCase: UserInfoUseCaseInterface
  private let contacts: [ContactType]
  weak var delegate: SignUpCoordinatingActionDelegate?
  private let disposeBag = DisposeBag()

  init(useCase: SignUpUseCaseInterface, userInfoUseCase: UserInfoUseCaseInterface, contacts: [ContactType]) {
    self.useCase = useCase
    self.userInfoUseCase = userInfoUseCase
    self.contacts = contacts
  }

  struct Input {
    let nextBtnTap: Driver<Void>
  }

  struct Output {
    let loadTrigger: Driver<Bool>
    let toast: Signal<String>
    let profileImage: Driver<Data?>
  }

  func transform(input: Input) -> Output {
    let toast = PublishSubject<String>()
    let loadTrigger = PublishRelay<Bool>()

    let contacts = Driver.just(self.contacts)

    let userinfo = Driver.just(())
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    let photos = userinfo.map { $0.photos }

    let phoneNum = userinfo.map { $0.phoneNumber }

    let imagesData = photos
      .withLatestFrom(phoneNum) { (key: $1, filenames: $0) }
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, components in
        owner.userInfoUseCase.fetchUserPhotos(key: components.key, fileNames: components.filenames)
          .catch { error in
            toast.onNext("사진을 불러오는데 실패했습니다.")
            return .just([])
          }
          .asObservable()
      }.asDriverOnErrorJustEmpty()

    // 이미지 업로드
    // SignUpRequest

    let imageUrls = input.nextBtnTap
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(imagesData)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, data in
        owner.useCase.uploadImage(data: data)
          .catch { error in
            toast.onNext("이미지 업로드에 실패했습니다.")
            return .just([])
          }
      }
      .asDriverOnErrorJustEmpty()

    let signUpRequest = Driver.combineLatest(imageUrls, userinfo, contacts) { urls, userinfo, contacts in
        var mutable = userinfo
        mutable.photos = urls
      return mutable.toRequest(contacts: contacts)
      }
      .flatMap { requestOrNil -> Driver<SignUpReq> in
        guard let request = requestOrNil else {
          toast.onNext("입력하신 회원 정보가 올바르지 않습니다.")
          return Driver.empty()
        }
        return Driver.just(request)
      }
      .debug("signUpRequest")

    let signUpResult = signUpRequest
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, request in
        owner.useCase.signUp(request: request)
          .asObservable()
          .catch { error in
            toast.onNext("회원가입에 실패했습니다.")
            return .empty()
          }
      }
      .asDriverOnErrorJustEmpty()

    signUpResult
      .withLatestFrom(phoneNum)
      .drive(with: self) { owner, phoneNum in
        owner.userInfoUseCase.savePhoneNumber(phoneNum)
        owner.delegate?.invoke(.nextAtSignUpComplete)
      }
      .disposed(by: disposeBag)

    return Output(
      loadTrigger: loadTrigger.asDriverOnErrorJustEmpty(),
      toast: toast.asSignal(onErrorSignalWith: .empty()),
      profileImage: imagesData.map { $0.first }
    )
  }
}
