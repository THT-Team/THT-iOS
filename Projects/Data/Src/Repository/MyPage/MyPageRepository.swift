//
//  MyPageRepository.swift
//  Data
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import Networks

import RxSwift
import RxMoya
import Moya
import Domain

public enum RepositoryEnvironment {
  case debug
  case release(Moya.Session)
}

public class BaseRepository<Target: TargetType>: ProviderProtocol {

  public var provider: MoyaProvider<Target>

  public init(_ environment: RepositoryEnvironment) {
    switch environment {
    case .debug:
      self.provider = Self.makeStubProvider()
    case .release(let session):
      self.provider = Self.makeProvider(session: session)
    }
  }
}

public typealias MyPageRepository = BaseRepository<MyPageTarget>

extension MyPageRepository: MyPageRepositoryInterface {
  public func updateReligion(_ religion: Religion) -> RxSwift.Single<Void> {
    return .just(())
  }
  
  public func updateSmoking(_ smoking: Frequency) -> RxSwift.Single<Void> {
    return .just(())
  }
  
  public func updateDrinking(_ drinking: Frequency) -> RxSwift.Single<Void> {
    return .just(())
  }

  public func updateHeight(_ height: Int) -> RxSwift.Single<Void> {
    return .just(())
  }

  public func updatePreferGender(_ gender: Gender) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .preferGender(gender.rawValue))
  }
  
  public func updateNickname(_ nickname: String) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .nickname(nickname))
  }
  
  public func updateIntroduction(_ introduction: String) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .introduction(introduction))
  }
  
  public func updateIdealType(_ emojies: [Domain.EmojiType]) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .idealType(emojies.map(\.idx)))
  }
  
  public func updateInterests(_ emojies: [Domain.EmojiType]) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .interests(emojies.map(\.idx)))
  }
  
  public func updateProfilePhotos(_ photos: [Domain.UserProfilePhoto]) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .profilePhoto(photos))
  }
  
  public func updatePhoneNumber(_ phoneNumber: String) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .phoneNumber(phoneNumber))
  }
  
  public func updateEmail(_ email: String) -> RxSwift.Single<Void> {
    requestWithNoContent(target: .email(email))
  }
  
  public func fetchUserContacts() -> RxSwift.Single<Int> {
    request(type: UserFriendContactRes.self, target: .fetchUserContacts)
      .map { $0.count }
  }
  
  public func updateUserContacts(contacts: [ContactType]) -> RxSwift.Single<Int> {
    request(type: UserFriendContactRes.self, target: .updateUserContacts(contacts))
      .map { $0.count }
  }

  public func fetchUser() -> Single<User> {
    
    return request(type: User.Res.self, target: .user)
      .map { $0.toDomain() }
  }

  public func updateAlarmSetting(_ settings: [String: Bool]) -> Single<Void> {
    requestWithNoContent(target: .updateAlarmSetting(settings))
  }

  public func withdrawal(reason: String, feedback: String) -> Single<Void> {
    requestWithNoContent(target: .withdrawal(reason: reason, feedback: feedback))
  }

  public func logout() -> Single<Void> {
    requestWithNoContent(target: .logout)
  }

  public func updateLocation(_ location: LocationReq) -> Single<Void> {
    requestWithNoContent(target: .location(location))
  }
}
