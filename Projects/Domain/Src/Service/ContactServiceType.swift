//
//  ContactServiceType.swift
//  Data
//
//  Created by Kanghos on 3/4/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

import RxSwift

public protocol ContactServiceType {
  func fetchContact() -> Single<[ContactType]>
}
