//
//  InquiryCoordinating+Action.swift
//  AuthInterface
//
//  Created by Kanghos on 7/21/24.
//

import Foundation

public protocol InquiryCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: InquiryCoordinatingAction)
}

public enum InquiryCoordinatingAction {
  case finish
}
