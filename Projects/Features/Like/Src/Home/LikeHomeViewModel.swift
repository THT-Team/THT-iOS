//
//  LikeViewModel.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/07.
//

import Foundation

import Core


protocol LikeHomeDelegate: AnyObject {
  func deinitTest()
}

final class LikeHomeViewModel {
  weak var delegate: LikeHomeDelegate?

  init() {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  deinit {
    TFLogger.ui.debug("\(#function) \(type(of: self))")
  }

  func test() {
    self.delegate?.deinitTest()
  }
}
