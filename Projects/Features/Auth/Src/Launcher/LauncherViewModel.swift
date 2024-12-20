//
//  LauncherViewModel.swift
//  AuthDemo
//
//  Created by Kanghos on 6/4/24.
//

import Foundation

import AuthInterface
import SignUpInterface
import Core

import RxSwift
import RxCocoa

protocol LauncherDelegate: AnyObject {
  func needAuth()
  func toMain()
}

public final class LauncherViewModel: ViewModelType {
  private var disposeBag = DisposeBag()
  private let useCase: AuthUseCaseInterface
  weak var delegate: LauncherDelegate?

  public struct Input {
    let viewDidLoad: Driver<Void>
  }

  public struct Output {
    let toast: Signal<String>
  }

  public init(useCase: AuthUseCaseInterface) {
    self.useCase = useCase
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()

    let needAuth = Driver.just(useCase.needAuth())

    let load = Driver.zip(needAuth, input.viewDidLoad) { needAuth, _ in needAuth }

    load
      .filter { $0 }
      .drive(with: self) { owner, needAuth in
        owner.delegate?.needAuth()
      }.disposed(by: disposeBag)

    load
      .filter { !$0 }
      .flatMapLatest(with: self) { owner, _ in
        owner.useCase.login()
          .debug("login")
          .asDriver(onErrorRecover: { error in
            TFLogger.dataLogger.error("\(error.localizedDescription)")
            toast.accept("로그인에 실패하였습니다. 다시 시도해주시기 바랍니다.\n\(error.localizedDescription)")
            return .empty()
          })
      }.drive(with: self) { owner, _ in
        owner.delegate?.toMain()
      }.disposed(by: disposeBag)

    return Output(
      toast: toast.asSignal()
    )
  }
}
