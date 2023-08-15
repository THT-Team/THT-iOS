//
//  HeartListViewModel.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import Foundation

import RxSwift
import RxCocoa

final class HeartListViewModel: ViewModelType {
  struct Input {

  }

  struct Output {

  }

  private let navigator: HeartNavigator

  init(navigator: HeartNavigator) {
    self.navigator = navigator
  }

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {


    return Output()

  }
}
