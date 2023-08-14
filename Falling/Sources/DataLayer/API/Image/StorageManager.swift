//
//  StorageManager.swift
//  Falling
//
//  Created by Kanghos on 2023/07/19.
//

import Foundation

import FirebaseStorage
import RxSwift
import RxMoya

protocol StorageManagerProtocol {
  func upload(data: Data, key: String) -> Single<URL>
  func download(key: String) -> Single<Data>
}

final class StorageManager: StorageManagerProtocol {
  private let storageReference: StorageReference

  init() {
    self.storageReference = Storage.storage().reference().child("/images")
  }

  func upload(data: Data, key: String) -> RxSwift.Single<URL> {
    let path = self.storageReference.child("\(key).jpg")
    return .create { observer in

      let metadata = StorageMetadata()
      metadata.contentType = "image/jpg"

      let task = path.putData(data, metadata: metadata) { (metadata, error) in
        if let error = error {
          observer(.failure(error))
        }
        if let metadata = metadata {
          print(metadata)
        }

        path.downloadURL(completion: { url, error in
          if let error = error {
            observer(.failure(error))
          }
          if let url = url {
            observer(.success(url))
          }
        })
      }

      return Disposables.create {
        task.cancel()
      }
    }
  }

  // 안드로이드와 별개의 storage를 이용하므로 일단 사용 자제
  func download(key: String) -> RxSwift.Single<Data> {
    let path = self.storageReference.child("\(key).jpg")
    let maxSize: Int64 = 1 * 1024 * 1024

    return .create { observer in
      let downloadTask = path.getData(maxSize: maxSize) { (data, error) in
        if let error = error {
          observer(.failure(error))
        }
        if let data = data {
          observer(.success(data))
        }
      }
      return Disposables.create {
        downloadTask.cancel()
      }
    }
  }
    
}
