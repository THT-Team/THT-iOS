//
//  LauncherViewModel.swift
//  AuthDemo
//
//  Created by Kanghos on 6/4/24.
//

import Foundation

import AuthInterface
import Core
import Domain

import RxSwift
import RxCocoa

public protocol LaunchOutput {
  var onAuthResult: ((LaunchAction) -> Void)? { get set }
}
public final class LauncherViewModel: ViewModelType, LaunchOutput {
  private let useCase: AuthUseCaseInterface
  private var disposeBag = DisposeBag()
  public var onAuthResult: ((LaunchAction) -> Void)?

  public struct Input {
    let viewDidLoad: Driver<Void>
  }

  public struct Output {
    let toast: Signal<String>
  }

  public init(_ useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()

    input.viewDidLoad
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, _ in
        owner.useCase.login()
          .asObservable()
          .map { _ in return true }
          .catch { error in
            TFLogger.domain.error("\(error.localizedDescription)")
            return .just(false)
          }
      }
      .asDriverOnErrorJustEmpty()
    .drive(with: self) { owner, hasToken in
      hasToken
      ? owner.onAuthResult?(.toMain)
      : owner.onAuthResult?(.needAuth)
    }
    .disposed(by: disposeBag)

    return Output(
      toast: toast.asSignal()
    )
  }
}
