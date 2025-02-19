//
//  StorageError.swift
//  Core
//
//  Created by Kanghos on 7/31/24.
//

import Foundation

public enum StorageError: Error {
  case notExisted
}

extension StorageError: LocalizedError {
  public var errorDescription: String? {
    return "파일이 존재하지 않습니다."
  }
}
