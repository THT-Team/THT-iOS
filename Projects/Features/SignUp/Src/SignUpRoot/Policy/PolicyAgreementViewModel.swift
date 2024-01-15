//
//  PolicyAgreementViewModel.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import Foundation

import Core
import DSKit

import RxSwift
import RxCocoa

protocol PolicyAgreementDelegate: AnyObject {
  func policyNextButtonTap()
}

final class PolicyAgreementViewModel: ViewModelType {
  
  weak var delegate: PolicyAgreementDelegate?

  struct Input {
    let agreeAllBtn: Driver<Void>
    let tosAgreeBtn: Driver<Void>
    let showTosDetailBtn: Driver<Void>
    let privacyAgreeBtn: Driver<Void>
    let showPrivacyDetailBtn: Driver<Void>
    let locationServiceAgreeBtn: Driver<Void>
    let showLocationServiceDetailBtn: Driver<Void>
    let marketingServiceAgreeBtn: Driver<Void>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let agreeAllRowImage: Driver<DSKitImages>
    let tosAgreeRowImage: Driver<DSKitImages>
    let privacyAgreeRowImage: Driver<DSKitImages>
    let locationServiceAgreeRowImage: Driver<DSKitImages>
    let marketingServiceRowImage: Driver<DSKitImages>
    let nextBtnStatus: Driver<Bool>
    let nextButtonTap: Driver<Void>
    let disposeble: Disposable
  }

  struct AgreeStatus {
    var tos: Bool
    var privacy: Bool
    var location: Bool
    var marketing: Bool

    var total: Bool {
      return isValid && marketing
    }
    var isValid: Bool {
      return tos && privacy && location
    }
    func reverse() -> AgreeStatus {
      AgreeStatus(tos: !total, privacy: !total, location: !total, marketing: !total)
    }
  }

  func transform(input: Input) -> Output {
    let agreeStatus = BehaviorRelay<AgreeStatus>(value: AgreeStatus(
      tos: false, privacy: false, location: false, marketing: false
    ))

    let totalStatus = input.agreeAllBtn
      .withLatestFrom(agreeStatus.asDriver()) { _, status in
        return status.reverse()
      }
      .do(onNext: { agreeStatus.accept($0) })

    let tosStatus = input.tosAgreeBtn
      .withLatestFrom(agreeStatus.asDriver()) { _, status in
        var mutable = status
        mutable.tos.toggle()
        return mutable
      }
      .do { agreeStatus.accept($0) }

    let privacyStatus = input.privacyAgreeBtn
      .withLatestFrom(agreeStatus.asDriver()) { _, status in
        var mutable = status
        mutable.privacy.toggle()
        return mutable
      }
      .do { agreeStatus.accept($0) }

    let locationStatus = input.locationServiceAgreeBtn
      .withLatestFrom(agreeStatus.asDriver()) { _, status in
        var mutable = status
        mutable.location.toggle()
        return mutable
      }
      .do { agreeStatus.accept($0) }

    let marketingStatus = input.marketingServiceAgreeBtn
      .withLatestFrom(agreeStatus.asDriver()) { _, status in
        var mutable = status
        mutable.marketing.toggle()
        return mutable
      }
      .do { agreeStatus.accept($0) }

    let agreeAllRowImage = agreeStatus.asDriver()
      .map { $0.total }
      .map { $0 ? DSKitAsset.Image.Component.checkCirSelect : DSKitAsset.Image.Component.checkCir }
      .asDriver(onErrorJustReturn: DSKitAsset.Image.Component.checkCir)

    let tosAgreeRowImage = agreeStatus.asDriver()
      .map { $0.tos }
      .map { $0 ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check }
      .asDriver(onErrorJustReturn: DSKitAsset.Image.Component.check)

    let privacyAgreeRowImage = agreeStatus.asDriver()
      .map { $0.privacy }
      .map { $0 ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check }
      .asDriver(onErrorJustReturn: DSKitAsset.Image.Component.check)

    let locationServiceAgreeRowImage = agreeStatus.asDriver()
      .map { $0.location }
      .map { $0 ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check }
      .asDriver(onErrorJustReturn: DSKitAsset.Image.Component.check)

    let marketingServiceRowImage = agreeStatus.asDriver()
      .map { $0.marketing }
      .map { $0 ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check }
      .asDriver(onErrorJustReturn: DSKitAsset.Image.Component.check)

    let nextBtnStatus = agreeStatus.asDriver()
      .debug("agreeStatus")
      .map { $0.isValid }

    let nextButtonTap = input.nextBtn
      .do(onNext: { [weak self] in
        self?.delegate?.policyNextButtonTap()
      })

    // TODO: Disposable로 만들어서 VC로 넘겨야할지 여기서 Disposed해야할지 아니면
    // 더 좋은 방법이 있을지 고민
    let disposeble = Driver.merge(totalStatus, tosStatus, privacyStatus, locationStatus, marketingStatus).drive()

    return Output(
      agreeAllRowImage: agreeAllRowImage,
      tosAgreeRowImage: tosAgreeRowImage,
      privacyAgreeRowImage: privacyAgreeRowImage,
      locationServiceAgreeRowImage: locationServiceAgreeRowImage,
      marketingServiceRowImage: marketingServiceRowImage,
      nextBtnStatus: nextBtnStatus,
      nextButtonTap: nextButtonTap,
      disposeble: disposeble
    )
  }
}
