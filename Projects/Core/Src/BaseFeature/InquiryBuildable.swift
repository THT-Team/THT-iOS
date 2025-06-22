//
//  InquiryBuildable.swift
//  AuthInterface
//
//  Created by Kanghos on 7/21/24.
//

import Core

public protocol InquiryBuildable {
  func build(rootViewControllable: ViewControllable) -> InquiryCoordinating
}

public protocol InquiryCoordinating: Coordinator {
  var finishFlow: (() -> Void)? { get set }

  func homeFlow()
}

