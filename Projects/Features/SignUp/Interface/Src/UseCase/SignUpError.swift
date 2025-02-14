//
//  SignUpError.swift
//  SignUpInterface
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

public enum SignUpError: Error {
  case alreadySignUp
  case duplicateNickname
  case invalidRequest
  case imageUploadFailed
  case fetchContactsFailed(Error)
}

extension SignUpError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .alreadySignUp:
      return "이미 가입된 계정입니다"
    case .duplicateNickname:
      return "이미 가입된 닉네임입니다"
    case .invalidRequest:
      return "잘못된 가입 요청입니다."
    case .imageUploadFailed:
      return "이미지 업로드에 실패하였습니다.\n다시 시도해주세요."
    case let .fetchContactsFailed(error):
      return "친구 목록을 가져오는데 실패하였습니다." + error.localizedDescription
    }
  }
}
