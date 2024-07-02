//
//  PolicyAgreementViewModel.swift
//  DSKit
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import Foundation
import SignUpInterface
import DSKit
import Core

open class BasePenddingViewModel {
  var disposeBag = DisposeBag()

  weak var delegate: SignUpCoordinatingActionDelegate?
  var pendingUser: PendingUser
  let useCase: SignUpUseCaseInterface

  init(useCase: SignUpUseCaseInterface, pendingUser: PendingUser) {
    self.useCase = useCase
    self.pendingUser = pendingUser
    TFLogger.cycle(name: self)
  }

  deinit {
    TFLogger.cycle(name: self)
  }
}

final class PolicyAgreementViewModel: BasePenddingViewModel, ViewModelType {
  enum CellAction {
    case Agree
    case WebView
  }

  struct Input {
    let viewWillAppear: Driver<Void>
    let agreeAllBtn: Driver<Void>
    let cellTap: Driver<(IndexPath, CellAction)>
    let nextBtn: Driver<Void>
  }

  struct Output {
    let agreeAllBtnStatus: Driver<Bool>
    let cellViewModels: Driver<[ServiceAgreementRowViewModel]>
    let nextBtnStatus: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let agreeStates = BehaviorRelay<[ServiceAgreementRowViewModel]>(value: [])
    let webViewTrigger = PublishRelay<String?>()
    let agreeStateShare = agreeStates.asDriver()

    useCase.fetchPolicy()
      .asDriver(onErrorJustReturn: [])
      .drive(agreeStates)
      .disposed(by: disposeBag)

    input.cellTap
      .withLatestFrom(agreeStateShare) { cellAction, rows in
        let (indexPath, action) = cellAction
        var rows = rows
        var row = rows[indexPath.row]

        switch action {
        case .Agree:
          row.isSelected.toggle()
          rows[indexPath.row] = row
          agreeStates.accept(rows)
          break
        case .WebView:
          print(row.model.detailLink ?? "링크 없음")
          webViewTrigger.accept(row.model.detailLink)
          break
        }
      }.drive()
      .disposed(by: disposeBag)

    webViewTrigger.asDriverOnErrorJustEmpty()
      .compactMap { $0 }
      .compactMap { URL(string: $0) }
      .drive(with: self) { owner, url in
        owner.delegate?.invoke(.agreementWebView(url), owner.pendingUser)
      }.disposed(by: disposeBag)

    let isAllSatisfy = agreeStateShare
      .map { $0.allSatisfy { $0.isSelected } }

    input.agreeAllBtn
      .withLatestFrom(agreeStateShare) { _, rows  in
        rows.map {
          var mutable = $0
          mutable.isSelected = true
          return mutable } }
      .drive(agreeStates)
      .disposed(by: disposeBag)

    let nextBtnStatus = agreeStateShare
      .map { $0.filter { $0.model.isRequired }
        .allSatisfy { $0.isSelected } }

    input.nextBtn
      .throttle(.milliseconds(500), latest: false)
      .withLatestFrom(nextBtnStatus)
      .filter { $0 }
      .withLatestFrom(agreeStateShare)
      .map { $0.reduce(into: [String: Bool]()) { $0[$1.model.name] = $1.isSelected }
      }.drive(with: self, onNext: { owner, agreements in
        owner.pendingUser.userAgreements = agreements
        owner.useCase.savePendingUser(owner.pendingUser)
        let isAgree = owner.pendingUser.userAgreements["marketingAgree", default: false]
        owner.useCase.updateMarketingAgreement(isAgree: isAgree)
        owner.delegate?.invoke(.nextAtPolicy, owner.pendingUser)
      })
      .disposed(by: disposeBag)

    return Output(
      agreeAllBtnStatus: isAllSatisfy,
      cellViewModels: agreeStateShare,
      nextBtnStatus: nextBtnStatus
    )
  }
}
