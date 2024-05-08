//
//  LocationService.swift
//  SignUpInterface
//
//  Created by kangho lee on 4/29/24.
//

import Foundation
import RxSwift

public protocol LocationServiceType {
  var publisher: PublishSubject<String> { get }
  func handleAuthorization(granted: @escaping (Bool) -> Void)
  func requestLocation()
  func requestAuthorization()
}
