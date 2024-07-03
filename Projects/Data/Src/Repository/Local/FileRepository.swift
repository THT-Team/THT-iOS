//
//  FileRepository.swift
//  Data
//
//  Created by Kanghos on 7/3/24.
//

import Foundation

import Core

public final class FileRepository: FileRepositoryInterface {

  private let fileManager: FileManager
  private let userDomain: URL

  public init() {
    self.fileManager = FileManager.default
    self.userDomain = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  public func save(fileName: String, data: Data) -> String? {
    let url = userDomain.appending(component: fileName)
    let directory = url.deletingLastPathComponent()

    do {
      if !fileManager.fileExists(atPath: directory.path()) {
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
      }
      try data.write(to: url)
      return url.lastPathComponent
    }  catch {
        TFLogger.dataLogger.error("\(error.localizedDescription)")
        return nil
      }
//    do {
//      try data.write(to: url)
//      return url.lastPathComponent
//    } catch {
//      TFLogger.dataLogger.error("Save Failed!")
//      return nil
//    }
  }

  public func fetch(fileName: String) -> Data? {
    let url = userDomain.appending(path: fileName, directoryHint: .notDirectory)
    do {
      return try Data(contentsOf: url)
    } catch {
      TFLogger.dataLogger.error("\(error.localizedDescription)")
      return nil
    }
  }
  
  public func delete(path: String) {
    do{
      try fileManager.removeItem(atPath: path)
    } catch {
      TFLogger.dataLogger.error("\(error.localizedDescription)")
    }
  }
}
