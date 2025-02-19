//
//  ChatHomeViewModel.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import Foundation

import Core
import ChatInterface
import Domain

import RxSwift
import RxCocoa

protocol ChatHomeDelegate: AnyObject {
  func itemTapped(_ room: ChatRoom)
  func notiTapped()
}

final class ChatHomeViewModel {
  private let chatUsecase: ChatUseCaseInterface

  weak var delegate: ChatCoordinatingActionDelegate?

  private var disposeBag = DisposeBag()

  struct Input {
    let onAppear: Driver<Void>
    let refresh: Driver<Void>
    let itemSelected: Driver<Int>
    let notiTap: Driver<Void>
  }

  struct Output {
    let chatRooms: Driver<[ChatRoom]>
  }

  init(chatUseCase: ChatUseCaseInterface) {
    self.chatUsecase = chatUseCase
    TFLogger.cycle(name: self)
  }
  deinit { TFLogger.cycle(name: self) }
}

extension ChatHomeViewModel: ViewModelType {

  func transform(input: Input) -> Output {
    let snapshot = BehaviorRelay<[ChatRoom]>(value: [])

    let onAppear = input.onAppear
      .filter { _ in snapshot.value.isEmpty }

    let chatRooms = Driver
      .merge(onAppear, input.refresh)
      .asObservable()
      .withUnretained(self)
      .flatMapLatest { owner, _ in
        owner.chatUsecase.rooms()
      }
      .map { rooms in
        var mutable = snapshot.value
        mutable = rooms
        snapshot.accept(mutable)
        return rooms
      }
      .asDriver(onErrorJustReturn: Array<ChatRoom>())

    input.itemSelected
      .withLatestFrom(snapshot.asDriver()) { $1[$0] }
      .drive(with: self, onNext: { owner, chatRoom in
        owner.delegate?.invoke(.roomItemTapped(chatRoom))
      }).disposed(by: disposeBag)

    input.notiTap
      .drive(with: self, onNext: { owner, _ in
        NotificationCenter.default.post(Notification(name: .needAuthLogout))
//        owner.delegate?.invoke(.notiTapped)
      }).disposed(by: disposeBag)

    return Output(
      chatRooms: chatRooms
    )
  }
}
