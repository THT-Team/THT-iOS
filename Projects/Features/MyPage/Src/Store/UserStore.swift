//
//  UserStore.swift
//  MyPageInterface
//
//  Created by Kanghos on 8/2/24.
//

import Foundation

import SignUpInterface
import Domain
import RxSwift
import Core
import MyPageInterface

public final class UserStore {
  @Injected private var myPageUseCase: MyPageUseCaseInterface

  var disposeBag = DisposeBag()

  public enum Action {
    case fetch
    case interests([EmojiType])
    case idealTypes([EmojiType])
    case smoke(Frequency)
    case drink(Frequency)
    case preferGender(Gender)
    case height(Int)
    case religion(Religion)
    case introduce(String)
    case nickname(String)
    case photos([UserProfilePhoto])
  }

  public enum Mutation {
    case toast(String)
    case error(Error)
    case interests([EmojiType])
    case idealTypes([EmojiType])
    case smoke(Frequency)
    case setUser(User)
    case drink(Frequency)
    case preferGender(Gender)
    case height(Int)
    case religion(Religion)
    case introduce(String)
    case nickname(String)
    case photos([UserProfilePhoto])
  }

  var state: User? = nil
  private let stream = BehaviorSubject<User?>(value: nil)

  public var binding: Observable<User?> {
    stream.asObservable()
  }

  private let toastPublisher = PublishSubject<String>()

  public var toastSignal: Observable<String> {
    toastPublisher.asObservable()
  }

  public init() {
    bind()
  }

  private let actionSubject = PublishSubject<Action>()

  private func bind() {

    let mutation = transform(action: actionSubject)

    let state = mutation
      .scan(state, accumulator: { [weak self] state, mutation in
        guard let self else { return state }
        return reduce(mutation: mutation)
      })
      .do(onNext: { [weak self] state in
        self?.state = state
      })

    state.share()
      .bind(to: stream)
      .disposed(by: disposeBag)
  }

  public func send(action: Action) {
    actionSubject.onNext(action)
  }

  func transform(action: Observable<Action>) -> Observable<Mutation> {
    action.flatMap { [weak self] action -> Observable<Mutation> in
      guard let self else { return .empty() }
      switch action {
      case .fetch:
        return self.myPageUseCase.fetchUser()
          .asObservable()
          .map { Mutation.setUser($0) }
          .catch { error in
            return .just(Mutation.error(error))
          }
      case .interests(let array):
        return self.myPageUseCase.updateInterest(array)
          .asObservable()
          .map { Mutation.interests(array) }
          .catch { error in
            return .just(Mutation.error(error))
          }
      case .idealTypes(let array):
        return self.myPageUseCase.updateIdealType(array)
          .asObservable()
          .map { Mutation.idealTypes(array) }
          .catch { error in
            return .just(Mutation.error(error))
          }
      case .smoke(let frequency):
        return .just(.smoke(frequency))
      case .drink(let frequency):
        return .just(.drink(frequency))
      case .height(let height):
        return .just(.height(height))
      case .religion(let religion):
        return .just(.religion(religion))
      case .nickname(let nickname):
        return .just(.nickname(nickname))
      case .preferGender(let gender):
        return .just(.preferGender(gender))
      case .introduce(let introduce):
        return .just(.introduce(introduce))
      case .photos(let photos):
        return self.myPageUseCase.updateProfilePhoto(photos)
          .asObservable()
          .flatMap { _ in
            return Observable.concat([
              .just(Mutation.toast("프로필 사진이 변경되었습니다.")),
              .just(Mutation.photos(photos))
            ])
          }
          .catch { error in
            return .just(Mutation.error(error))
          }
      }
    }
  }

  func reduce(mutation: Mutation) -> User? {
    var newState = state
    switch mutation {
    case .interests(let array):
      newState?.interestsList = array
    case .idealTypes(let array):
      newState?.idealTypeList = array
    case .smoke(let frequency):
      newState?.smoking = frequency
    case .setUser(let user):
      newState = user
    case .error(let error):
      print(error)
    case .toast(let message):
      toastPublisher.onNext(message)
      print(message)
    case .drink(let frequency):
      newState?.drinking = frequency
    case .preferGender(let gender):
      newState?.preferGender = gender
    case .height(let height):
      newState?.tall = height
    case .religion(let religion):
      newState?.religion = religion
    case .introduce(let text):
      newState?.introduction = text
    case .nickname(let name):
      newState?.username = name
    case .photos(let photos):
      newState?.userProfilePhotos = photos
    }
    return newState
  }
}
