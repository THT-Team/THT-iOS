//
//  FileRepository.swift
//  Core
//
//  Created by Kanghos on 7/3/24.
//

import Foundation

public protocol FileRepositoryInterface {
  typealias FileModel = (fileName: String, data: Data)
  func fetch(fileName: String) -> Data?
  func delete(path: String)
  @discardableResult
  func save(fileName: String, data: Data) -> String?
}

public extension FileRepositoryInterface {
  func fetch(fileNames: [String]) -> [Data] {
    print(fileNames)
    return fileNames.reduce([]) {
      guard let data = fetch(fileName: $1) else {
        return $0
      }
      return  $0 + [data]
    }
  }

  func save(_ fileModels: [FileModel]) -> [String] {
    fileModels.reduce([]) {
      guard let name = save(fileName: $1.fileName, data: $1.data) else {
        return $0
      }
      return $0 + [name]
    }
  }
}
