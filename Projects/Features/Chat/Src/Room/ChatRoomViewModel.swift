//
//  ChatRoomViewModel.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import Foundation

import Core
import ChatInterface

import RxSwift
import RxCocoa

protocol ChatRoomDelegate: AnyObject {
  
}

final class ChatRoomViewModel {
  private let chatUsecase: ChatUseCaseInterface
  private let chatRoom: Domain

  weak var delegate: ChatCoordinatingActionDelegate?

  private var disposeBag = DisposeBag()

  struct Input {
    let onAppear: Driver<Void>
    let refresh: Driver<Void>
    let backButtonTapped: Driver<Void>
    let reportButtonTapped: Driver<Void>
    let exitButtonTapped: Driver<Void>
  }

  struct Output {
    let items: Driver<[Domain]>
    let room: Driver<Domain>
  }

  init(
    chatUseCase: ChatUseCaseInterface,
    chatRoom: Domain
  ) {
    self.chatUsecase = chatUseCase
    self.chatRoom = chatRoom
    TFLogger.cycle(name: self)
  }
  deinit { TFLogger.cycle(name: self) }
}

extension ChatRoomViewModel: ViewModelType {
  typealias Domain = ChatRoom

  func transform(input: Input) -> Output {
    let snapshot = BehaviorRelay<[Domain]>(value: [])

    let room = Driver.just(self.chatRoom)

    let onAppear = input.onAppear
      .filter { _ in snapshot.value.isEmpty }

    let items = Driver
      .merge(onAppear, input.refresh)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, _ in
        owner.chatUsecase.fetchRooms()
      }
      .map { rooms in
        var mutable = snapshot.value
        mutable = rooms
        snapshot.accept(mutable)
        return rooms
      }
      .asDriver(onErrorJustReturn: Array<Domain>())

    input.backButtonTapped
      .drive(with: self, onNext: { owner, _ in
        owner.delegate?.invoke(.backButtonTapped)
      }).disposed(by: disposeBag)

    input.exitButtonTapped
      .drive(with: self, onNext: { owner, _ in
        owner.delegate?.invoke(.exitTapped)
      }).disposed(by: disposeBag)

    input.reportButtonTapped
      .drive(with: self, onNext: { owner, _ in
        owner.delegate?.invoke(.reportTapped)
      }).disposed(by: disposeBag)

    return Output(
      items: items,
      room: room
    )
  }
}
