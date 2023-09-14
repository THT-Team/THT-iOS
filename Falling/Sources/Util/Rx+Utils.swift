//
//  Rx+Utils.swift
//  Falling
//
//  Created by Kanghos on 2023/08/10.
//

import UIKit

import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
        return ControlEvent(events: source)
    }

    var viewWillAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }

    var viewDidAppear: ControlEvent<Bool> {
        let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

extension ObservableType {
  func asDriverOnErrorJustEmpty() -> Driver<Element> {
    asDriver { error in
        .empty()
    }
  }
  func mapToVoid() -> Observable<Void> {
    map { _ in }
  }
}
