//
//  PolicyAgreementViewModel.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import Foundation
import SignUpInterface
import DSKit

final class PolicyAgreementViewModel: ViewModelType {

  weak var delegate: SignUpCoordinatingActionDelegate?

  enum CellAction {
    case Agree
    case WebView
  }

  struct Input {
    let viewDidAppear: Driver<Void>
    let agreeAllBtn: Driver<Void>
    let cellTap: Driver<(IndexPath, CellAction)>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let agreeAllBtnStatus: Driver<Bool>
    let cellViewModels: Driver<[ServiceAgreementRowViewModel]>
    let nextBtnStatus: Driver<Bool>
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

  private let useCase: SignUpUseCaseInterface
  private let userInfoUseCase: UserInfoUseCaseInterface
  private var disposeBag = DisposeBag()

  init(useCase: SignUpUseCaseInterface, userInfoUseCase: UserInfoUseCaseInterface) {
    self.useCase = useCase
    self.userInfoUseCase = userInfoUseCase
  }

  func transform(input: Input) -> Output {
    let agreeStates = BehaviorRelay<[ServiceAgreementRowViewModel]>(value: [])
    let webViewTrigger = PublishRelay<String?>()

    let userinfo = input.viewDidAppear
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.userInfoUseCase.fetchUserInfo()
          .catchAndReturn(UserInfo(phoneNumber: ""))
          .asObservable()
      }
      .asDriverOnErrorJustEmpty()

    let localAgreements = userinfo.map { $0.userAgreements }

    let remoteAgreements = input.viewDidAppear
      .asObservable()
      .withUnretained(self)
      .flatMap { owner, _ in
        owner.useCase.fetchAgreements()
          .catchAndReturn([])
          .asObservable()
      }
      .asDriver(onErrorJustReturn: [])
      .map { array in
        array.map {
          ServiceAgreementRowViewModel.init(model: $0, checkImage: DSKitAsset.Image.Component.check)
        }
      }
    Driver.zip(localAgreements, remoteAgreements) { local, remote in
      guard let local else { return remote }
      var mutableRemoteArray = remote

      local.forEach { key, value in
        if let index = mutableRemoteArray.firstIndex (where: { $0.model.name == key }) {
          mutableRemoteArray[index].checkImage = value ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check
        }
      }
      return mutableRemoteArray
    }.drive(agreeStates)
      .disposed(by: disposeBag)

    input.cellTap
      .withLatestFrom(agreeStates.asDriver()) { cellAction, rows in
        let (indexPath, action) = cellAction
        var rows = rows
        var row = rows[indexPath.row]

        switch action {
        case .Agree:
          print(row.checkImage.name)
          row.checkImage = row.checkImage.name == DSKitAsset.Image.Component.check.name ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check
          rows[indexPath.row] = row
          agreeStates.accept(rows)
          break
        case .WebView:
          print(row.model.detailLink)
          webViewTrigger.accept(row.model.detailLink)
          break
        }
      }.drive()
      .disposed(by: disposeBag)

    webViewTrigger.asDriverOnErrorJustEmpty()
      .compactMap { $0 }
      .compactMap { URL(string: $0) }
      .drive(with: self) { owner, url in
        owner.delegate?.invoke(.agreementWebView(url))
      }.disposed(by: disposeBag)

    let agreeAllBtnStatus = agreeStates
      .asDriver()
      .map { $0.allSatisfy { row in
        row.checkImage.name == DSKitAsset.Image.Component.checkSelect.name
      } }

    input.agreeAllBtn
      .withLatestFrom(agreeAllBtnStatus)
      .withLatestFrom(agreeStates.asDriver()) { buttonStatus, models in
        models.map {
          var row = $0
          row.checkImage = !buttonStatus ? DSKitAsset.Image.Component.checkSelect : DSKitAsset.Image.Component.check
          return row
        }
      }
      .drive(agreeStates)
      .disposed(by: disposeBag)

    let nextBtnStatus = agreeStates
      .asDriver()
      .map { $0.filter { row in row.model.isRequired }
          .allSatisfy { row in
            row.checkImage.name == DSKitAsset.Image.Component.checkSelect.name
          }
      }

    input.nextBtn
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(agreeStates.asDriver())
      .filter { $0
        .filter { row in
          row.model.isRequired
        }
        .allSatisfy { row in
          row.checkImage.name == DSKitAsset.Image.Component.checkSelect.name
        }
      }
      .map { $0.map {
        let key = $0.model.name
        let value = $0.checkImage.name == DSKitAsset.Image.Component.checkSelect.name ? true : false
        return (key, value)
      } }
      .map { Dictionary(uniqueKeysWithValues: $0) }
      .withLatestFrom(userinfo) { agreements, userinfo in
        var mutableUserInfo = userinfo
        mutableUserInfo.userAgreements = agreements
        return mutableUserInfo
      }
      .drive(with: self, onNext: { owner, userinfo in
        owner.userInfoUseCase.updateUserInfo(userInfo: userinfo)
        owner.delegate?.invoke(.nextAtPolicy)
      })
      .disposed(by: disposeBag)

    return Output(
      agreeAllBtnStatus: agreeAllBtnStatus,
      cellViewModels: agreeStates.asDriver(),
      nextBtnStatus: nextBtnStatus
    )
  }
}
