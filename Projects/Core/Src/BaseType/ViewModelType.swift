//
//  ViewModelType.swift
//  Core
//
//  Created by Kanghos on 2023/12/07.
//

import Foundation

public protocol ViewModelType {
  associatedtype Input
  associatedtype Output

  func transform(input: Input) -> Output
}
