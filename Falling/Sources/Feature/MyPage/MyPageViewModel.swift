//
//  MyPageViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  private let navigator: MyPageNavigator
  
  init(navigator: MyPageNavigator) {
    self.navigator = navigator
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    
    
    return Output()
    
  }
}
