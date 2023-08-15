//
//  MainViewModel.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import RxSwift
import RxCocoa

final class MainViewModel: ViewModelType {
  struct Input {
    
  }
  
  struct Output {
    
  }
  
  private let navigator: MainNavigator
  
  init(navigator: MainNavigator) {
    self.navigator = navigator
  }
  
  var disposeBag: DisposeBag = DisposeBag()
  
  func transform(input: Input) -> Output {
    
    
    return Output()
    
  }
}
