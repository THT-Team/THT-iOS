//
//  FallingHomeViewModel.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import Core
import FallingInterface

import RxSwift
import RxCocoa
import Foundation

final class FallingHomeViewModel: ViewModelType {
  
  private let fallingUseCase: FallingUseCaseInterface
  
  //  weak var delegate: FallingHomeDelegate?

  weak var delegate: FallingHomeActionDelegate?

  var disposeBag: DisposeBag = DisposeBag()
  private let alertActionSignal = PublishRelay<FallingHomeAlertAction>()

  struct Input {
    let initialTrigger: Driver<Void>
    let timeOverTrigger: Driver<AnimationAction>
    let cellButtonAction: Driver<FallingCellButtonAction>
    let reportButtonTapTrigger: Signal<Void>
  }
  
  struct Output {
    let userList: Driver<[FallingUser]>
    let nextCardIndexPath: Driver<IndexPath>
    let likeButtonAction: Driver<IndexPath>
    let rejectButtonAction: Driver<IndexPath>
    let deleteCard: Driver<IndexPath>
    let activateTimer: Signal<Void>
    let toast: Signal<String>
  }
  
  init(fallingUseCase: FallingUseCaseInterface) {
    self.fallingUseCase = fallingUseCase
  }
  
  func transform(input: Input) -> Output {
    let currentIndexRelay = BehaviorRelay<Int>(value: 0)
    let timeOverTrigger = input.timeOverTrigger
    let snapshot = BehaviorRelay<[FallingUser]>(value: [])
    let toast = PublishRelay<String>()

    let usersResponse = input.initialTrigger
      .flatMapLatest { [unowned self] _ in
        self.fallingUseCase.user(alreadySeenUserUUIDList: [], userDailyFallingCourserIdx: 1, size: 100)
          .asDriver(onErrorJustReturn: .init(selectDailyFallingIdx: 0, topicExpirationUnixTime: 0, userInfos: []))
      }
    
    let userList = usersResponse.map {
      snapshot.accept($0.userInfos)
      return $0.userInfos
    }
    
    let updateUserListTrigger = userList.map { _ in
      currentIndexRelay.accept(currentIndexRelay.value)
    }
    
    let updateScrollIndexTrigger = timeOverTrigger.withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0)) { action, index in
      switch action {
      case .scroll: currentIndexRelay.accept(index + 1)
      case .delete: currentIndexRelay.accept(index + 1)
      }
    }
    
    let nextCardIndexPath = Driver.merge(
      updateUserListTrigger,
      updateScrollIndexTrigger
    ).withLatestFrom(currentIndexRelay.asDriver(onErrorJustReturn: 0)
      .map { IndexPath(row: $0, section: 0) })
    
    let likeButtonAction = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .like(indexPath) = action {
          return indexPath
        }
        return nil
      }
    
    let rejectButtonAction = input.cellButtonAction
      .compactMap { action -> IndexPath? in
        if case let .reject(indexPath) = action {
          return indexPath
        }
        return nil
      }

    input.reportButtonTapTrigger
      .emit(with: self) { owner, _ in
        owner.delegate?.invoke(.toReportBlockAlert(listener: owner))
      }.disposed(by: disposeBag)

    // TODO: block과 report 분기해서 API 태우기
    let reportAndBlockTrigger = self.alertActionSignal
      .filter { $0 != .cancel }

    let deleteCard = reportAndBlockTrigger
      .withLatestFrom(currentIndexRelay)
      .map { IndexPath(item: $0, section: 0) }
      .asDriverOnErrorJustEmpty()

      reportAndBlockTrigger
      .withLatestFrom(currentIndexRelay) { action, index in
        (action, IndexPath(item: index, section: 0))
      }
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, component in
        let (action, indexPath) = component
        // TODO: action을 신고 차단 따라서 API 태우기 + user UUID 같이
        print(action)
        print("API 태우기")
        toast.accept("차단하기가 완료되었습니다. 해당 사용자와\n서로 차단되며 설정에서 확인 가능합니다.")
      }
      .disposed(by: disposeBag)

    return Output(
      userList: userList,
      nextCardIndexPath: nextCardIndexPath,
      likeButtonAction: likeButtonAction,
      rejectButtonAction: rejectButtonAction,
      deleteCard: deleteCard,
      activateTimer: self.alertActionSignal.asSignal().map { _ in },
      toast: toast.asSignal()
    )
  }
}

extension FallingHomeViewModel: BlockOrReportAlertListener {
  enum FallingHomeAlertAction: Equatable {
    case cancel
    case block
    case report(reason: String)
  }

  func didTapAction(_ action: BlockOrReportAction) {
    switch action {
    case .block:
      self.delegate?.invoke(.toBlockAlert(listener: self))
    case .report:
      self.delegate?.invoke(.toReportAlert(listener: self))
    case .cancel:
      self.alertActionSignal.accept(.cancel)
    }
  }
}

extension FallingHomeViewModel: BlockAlertListener {
  func didTapAction(_ action: BlockAlertAction) {
    switch action {
    case .block:
      self.alertActionSignal.accept(.block)
    case .cancel:
      self.alertActionSignal.accept(.cancel)
    }
  }
}

extension FallingHomeViewModel: ReportAlertListener {
  func didTapAction(_ action: ReportAlertAction) {
    switch action {
    case let .didTap(menu):
      self.alertActionSignal.accept(.report(reason: menu.key))
    case .cancel:
      self.alertActionSignal.accept(.cancel)
    }
  }
}
