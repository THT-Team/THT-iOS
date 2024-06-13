//
//  Rx+Util.swift
//  Core
//
//  Created by Kanghos on 2023/12/20.
//

import UIKit

import RxCocoa
import RxSwift

public extension Reactive where Base: UIViewController {
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
  
  var viewWillDisAppear: ControlEvent<Bool> {
    let source = methodInvoked(#selector(Base.viewWillDisappear)).map { $0.first as? Bool ?? false }
    return ControlEvent(events: source)
  }
}

public extension ObservableType {
  func asDriverOnErrorJustEmpty() -> Driver<Element> {
    asDriver { error in
        .empty()
    }
  }
  func mapToVoid() -> Observable<Void> {
    map { _ in }
  }
}

public extension PrimitiveSequence where Trait == SingleTrait {
  func asDriverOnErrorJustEmpty() -> Driver<Element> {
    asDriver { error in
        .empty()
    }
  }
}

extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    map { _ in }
  }

  public func flatMapLatest<A: AnyObject, O: SharedSequenceConvertibleType>(with obj: A, selector: @escaping (A, Element) -> O) -> SharedSequence<O.SharingStrategy, O.Element> {
    flatMapLatest { [weak obj] value -> SharedSequence<O.SharingStrategy, O.Element> in
      obj.map { selector($0, value).asSharedSequence() }
      ?? .empty()
    }
  }
}

public extension ObservableType {
  func flatMapLatest<A: AnyObject, O: ObservableType>(weak obj: A, selector: @escaping (A, Self.Element) throws -> O) -> Observable<O.Element> {
    return flatMapLatest { [weak obj] value -> Observable<O.Element> in
      try obj.map { try selector($0, value).asObservable() } ?? .empty() }
  }
}
