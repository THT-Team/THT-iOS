//
//  WithdrawalDetailViewModel.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/4/24.
//

import Foundation

import Core

import RxSwift
import RxCocoa
import DSKit
import Domain

public final class WithdrawalDetailViewModel: ViewModelType {
  let withdrawalDetail: WithdrawalReasonDetail
  private let useCase: MyPageUseCaseInterface
  private var disposeBag = DisposeBag()

  var onWithdrawComplete: (() -> Void)?

  init(withdrawalDetail: WithdrawalReasonDetail, useCase: MyPageUseCaseInterface) {
    self.withdrawalDetail = withdrawalDetail
    self.useCase = useCase
  }

  public struct Input {
    let load: Driver<Void>
    let selectedIndexPath: Signal<IndexPath>
    let withdrawalTap: Signal<Void>
    let otherText: Driver<String>
  }

  public struct Output {
    let models: Driver<[ReasonModel]>
  }

  public func transform(input: Input) -> Output {
    let reasonArray = PublishSubject<[ReasonModel]>()
    let model = Driver.just(self.withdrawalDetail)

    input.load
      .withLatestFrom(model)
      .map(\.reasonArray)
      .map { array in
        array
          .map { ReasonModel($0.rawValue, isSelected: false) }
      }
      .drive(reasonArray)
      .disposed(by: disposeBag)

    // TODO: 로직 개선 어떻게 할 수 있을까?
    let selectedSignal = input.selectedIndexPath.map(\.item)
    let otherText = input.otherText.startWith("")
    let selectedItem = reasonArray.asDriverOnErrorJustEmpty()
      .map { $0.first(where: \.isSelected) }

    let currentState = Driver.combineLatest(otherText, selectedItem)

    let validation = currentState
      .map { text, item in
      item?.isSelected == true || text.isEmpty == false
    }

    input.withdrawalTap
      .throttle(.milliseconds(300), latest: false)
      .withLatestFrom(validation)
      .filter { $0 }
      .withLatestFrom(currentState)
      .map { (reason: $0.1?.description ?? "기타", feedback: $0.0) }
      .asDriver(onErrorDriveWith: .empty())
      .flatMapLatest(with: self) { owner, item -> Driver<Void> in
        owner.useCase.withdrawal(reason: item.reason, feedback: item.feedback)
          .asDriver { error in
            return .empty()
          }
      }
      .drive(with: self) { owner, _ in
        owner.onWithdrawComplete?()
      }.disposed(by: disposeBag)

    selectedSignal
      .asObservable()
      .observe(on: ConcurrentDispatchQueueScheduler(qos: .userInteractive))
      .withLatestFrom(reasonArray) { index, array -> [ReasonModel] in
        array.enumerated().map {
          ReasonModel($1.description, isSelected: $0 == index)
        }
      }
      .subscribe(reasonArray)
      .disposed(by: disposeBag)

    return Output(
      models: reasonArray.asDriverOnErrorJustEmpty()
    )
  }
}

struct ReasonAndFeedbackModel {
  let reason: String
  let feedback: String
}
