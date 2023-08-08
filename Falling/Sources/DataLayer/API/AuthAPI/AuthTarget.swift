//
//  UserTarget.swift
//  Falling
//
//  Created by Kanghos on 2023/07/10.
//

import Moya
import Foundation

enum AuthTarget {
	case phoneValidationCodeSend(phoneNumber: String)
  case signup(request: SignUpRequest)
  case signup_sns
  case login(request: LoginRequest)
  case login_sns

  case certificate(String)
  case user_info(String)
  case nick_duplicate_check(String)
}

extension AuthTarget: BaseTargetType {

  var path: String {
    switch self {
		case let .phoneValidationCodeSend(phoneNumber):
			return "users/join/certification/phone-number/\(phoneNumber)"
    case .signup:
      return "users/join/signup"
    case .signup_sns:
      return "users/join/signup/sns"
    case .login:
      return "users/login/normal"
    case .login_sns:
      return "users/login/sns"
    case .certificate(let phoneNumber):
      return "users/join/certification/phone-number/\(phoneNumber)"
    case .user_info(let phoneNumber):
      return "users/join/exist/user-info/\(phoneNumber)"
    case .nick_duplicate_check(let nickName):
      return "users/join/nick0name/duplicate-check/\(nickName)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .signup, .signup_sns, .login, .login_sns:
      return .post
    default:
      return .get
    }
  }

  // Request의 파라미터를 결정한다.
  var task: Task {
    switch self {
    case .signup(let request):
      return .requestParameters(parameters: request.toDictionary(),
                                encoding: JSONEncoding.default)
    case .certificate:
      return .requestPlain
    case .login(let request):
      return .requestParameters(parameters: request.toDictionary(), encoding: JSONEncoding.default)
    default:
      return .requestPlain
    }
  }

}
