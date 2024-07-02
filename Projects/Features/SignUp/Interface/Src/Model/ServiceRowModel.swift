//
//  ServiceRowModel.swift
//  SignUpInterface
//
//  Created by Kanghos on 7/27/24.
//

import Foundation

public struct ServiceAgreementRowViewModel {
  public let model: AgreementElement
  public var isSelected: Bool

  public init(model: AgreementElement, isSelected: Bool) {
    self.model = model
    self.isSelected = isSelected
  }
}
