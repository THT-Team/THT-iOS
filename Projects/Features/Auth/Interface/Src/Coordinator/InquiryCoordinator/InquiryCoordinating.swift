//
//  InquiryCoordinator.swift
//  AuthInterface
//
//  Created by Kanghos on 7/21/24.
//

import Foundation

import Core

public protocol InquiryCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  func homeFlow()
}
