//
//  StorageManager.swift
//  Falling
//
//  Created by Kanghos on 2023/07/19.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    let storage = Storage.storage().reference()

//    func upload(_ data: Data, _ block: @escaping (Result<String, Error>) -> Void) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyMMdd-hhmmss"
//        let name = formatter.string(from: Date()) + UUID().uuidString
//        let storageRef = storage.child("images/\(name).jpg")
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpeg"
//
//        let uploadTask = storageRef.putData(data, metadata: metaData) { result in
//            switch result {
//            case .success(let success):
//                print(success)
//
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
//        let observer = uploadTask.observe(.progress) { snapshot in
//            snapshot.progress
//          // A progress event occurred
//        }
//
//    }
    
}
