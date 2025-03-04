//
//  InquiryCoordinator.swift
//  Core
//
//  Created by Kanghos on 3/4/25.
//

import Foundation

public protocol InquiryCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  func homeFlow()
}
