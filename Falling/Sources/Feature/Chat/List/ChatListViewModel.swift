//
//  ChatListViewModel.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

import RxSwift
import RxCocoa

final class ChatListViewModel: ViewModelType {
  struct Input {
    let selectedRoom: Driver<Int>
  }

  struct Output {
    let toRoom: Driver<Void>
  }

  private let navigator: ChatNavigator

  init(navigator: ChatNavigator) {
    self.navigator = navigator
  }

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let selected = input.selectedRoom
    let toRoom = selected
      .do(onNext: { [weak self] index in
        self?.navigator.toImageTest()
      }).map { _ in }
    return Output(toRoom: toRoom)

  }
}
