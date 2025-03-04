//
//  String+Util.swift
//  Data
//
//  Created by Kanghos on 3/4/25.
//  Copyright © 2025 THT. All rights reserved.
//

import Foundation

extension String {
  public func sanitizedPhoneNumber() -> String {
    self
      .replacing(/^(\+?\d{1,3}\s?)/, with: "0")
      .replacing(/[-\s]/, with: "")
  }
}
