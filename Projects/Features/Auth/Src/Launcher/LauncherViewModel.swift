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
  private var disposeBag = DisposeBag()
  public var onAuthResult: ((LaunchAction) -> Void)?

  public struct Input {
    let viewDidLoad: Driver<Void>
  }

  public struct Output {
    let toast: Signal<String>
  }

  public init() {
  }

  deinit {
    TFLogger.cycle(name: self)
  }

  public func transform(input: Input) -> Output {
    let toast = PublishRelay<String>()

    input.viewDidLoad.map {
      let token = UserDefaultRepository.shared.fetchModel(for: .token, type: Token.self)
      return (token != nil)
    }
    .drive(with: self) { owner, hasToken in
      hasToken
      ? owner.onAuthResult?(.toMain)
      : owner.onAuthResult?(.needAuth)
    }.disposed(by: disposeBag)

    return Output(
      toast: toast.asSignal()
    )
  }
}
