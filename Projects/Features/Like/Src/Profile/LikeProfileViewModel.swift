//
//  LikeProfileViewModel.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/20.
//

import Foundation

import DSKit
import LikeInterface
import Domain

public final class LikeProfileViewModel: ViewModelType {
  private let userUseCase: UserDomainUseCaseInterface
  private let like: Like
  private var disposeBag = DisposeBag()

  var onDismiss: ((Bool) -> Void)?
  var onReport: ((((UserReportAction) -> Void)?) -> Void)?
  var onHandleLike: (LikeProfileHandler)?

  public init(userUseCase: UserDomainUseCaseInterface, likItem: Like) {
    self.userUseCase = userUseCase
    self.like = likItem
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public struct Input {
    let trigger: Signal<Void>
    let rejectTrigger: Signal<Void>
    let likeTrigger: Signal<Void>
    let closeTrigger: Signal<Void>
    let reportTrigger: Signal<Void>
  }

  public struct Output {
    let topic: Driver<TopicViewModel>
    let sections: Driver<[ProfileDatailSection]>
    let isBlurHidden: Driver<Bool>
  }

  public func transform(input: Input) -> Output {
    let like = Signal.just(self.like)
    let userReportActionRelay = PublishRelay<UserReportType>()
    let errorSubject = PublishSubject<Error>()
    let isBlurHidden = BehaviorRelay<Bool>(value: true)
    let profileAction = PublishSubject<LikeProfileAction>()

    let userInfo = input.trigger
      .asObservable()
      .withUnretained(self) { owner, _ in owner }
      .flatMap { owner -> Observable<User> in
        owner.userUseCase.user(owner.like.userUUID)
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()
      .map { $0.toProfileSection() }

    Signal<LikeProfileAction>.merge(
      input.rejectTrigger
        .withLatestFrom(like) { .remove($1) },
      input.likeTrigger
        .withLatestFrom(like) { .chat($1) },
      input.closeTrigger
        .map { .cancel }
    )
    .emit(to: profileAction)
    .disposed(by: disposeBag)

    input.reportTrigger
      .emit(with: self) { owner, _ in
        isBlurHidden.accept(false)
        owner.onReport? {
          isBlurHidden.accept(true)
          switch $0 {
          case .block:
            userReportActionRelay.accept(.block(owner.like.userUUID))
          case let .report(reason):
            userReportActionRelay.accept(.report(owner.like.userUUID, reason))
          case .cancel: break
          }
        }
      }
      .disposed(by: disposeBag)

    userReportActionRelay
      .withUnretained(self)
      .flatMapLatest { owner, action -> Observable<LikeProfileAction> in
        owner.userUseCase.userReport(action)
          .map { _ -> LikeProfileAction in
            switch action {
            case .block: .toast(UserToast.block.message)
            case .report: .toast(UserToast.report.message)
            }
          }
          .asObservable()
          .catch { error in
            errorSubject.onNext(error)
            return .empty()
          }
      }
      .subscribe(profileAction)
      .disposed(by: disposeBag)

    profileAction
      .subscribe(with: self, onNext: { owner, action in
        switch action {
        case .cancel:
          owner.onHandleLike?(.cancel)
          owner.onDismiss?(false)
        case .chat(let id):
          owner.onHandleLike?(.chat(id))
          owner.onDismiss?(false)
        case .remove(let like):
          owner.onHandleLike?(.remove(like))
          owner.onDismiss?(true)
        case .toast(let msg):
          owner.onHandleLike?(.toast(msg))
          owner.onDismiss?(true)
        }
      })
      .disposed(by: disposeBag)

    return Output(
      topic: Driver.just(self.like).map { TopicViewModel(topic: $0.topic, issue: $0.issue) },
      sections: userInfo,
      isBlurHidden: isBlurHidden.asDriver()
    )
  }
}
