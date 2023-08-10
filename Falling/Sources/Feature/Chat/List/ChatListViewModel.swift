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
    
  }

  struct Output {

  }

  private let navigator: ChatNavigator

  init(navigator: ChatNavigator) {
    self.navigator = navigator
  }

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {
   

    return Output()

  }
}
