//
//  SignUpRepository.swift
//  Data
//
//  Created by kangho lee on 5/1/24.
//

import Foundation

import SignUpInterface
import Networks

import RxSwift
import RxMoya
import Moya
import Contacts

public final class SignUpRepository: ProviderProtocol {
  public typealias Target = SignUpTarget
  public var provider: MoyaProvider<Target>
  
  public init(isStub: Bool, sampleStatusCode: Int, customEndpointClosure: ((Target) -> Endpoint)?) {
    self.provider = Self.consProvider(isStub, sampleStatusCode, customEndpointClosure)
  }
}

extension SignUpRepository: SignUpRepositoryInterface {
  public func certificate(phoneNumber: String) -> RxSwift.Single<Int> {
    Single.just(PhoneValidationResponse(phoneNumber: "01012345678", authNumber: 123456))
      .map { $0.authNumber }
    
    //    request(type: PhoneValidationResponse.self, target: .certificate(phoneNumber: phoneNumber))
  }
  
  public func checkExistence(phoneNumber: String) -> RxSwift.Single<SignUpExistRes> {
    request(type: SignUpExistRes.self, target: .checkExistence(phoneNumber: phoneNumber))
  }
  
  public func checkNickname(nickname: String) -> RxSwift.Single<Bool> {
    request(type: UserNicknameValidRes.self, target: .checkNickname(nickname: nickname))
      .map { $0.isDuplicate }
  }
  
  public func idealTypes() -> RxSwift.Single<[EmojiType]> {
    request(type: [EmojiType].self, target: .idealTypes)
  }
  
  public func interests() -> RxSwift.Single<[EmojiType]> {
    request(type: [EmojiType].self, target: .interests)
  }
  
  public func block() -> Single<Int> {
    let store = CNContactStore()
    
    request(type: UserFriendContactRes.self, target: .block(contacts: contacts))
      .map { $0.count }
  }
}

extension SignUpRepository {
  private func fetchContacts() async throws {
    var mutable = [UserFriendContactReq.Contact]()
    let store = CNContactStore()
    let _ = try await store.requestAccess(for: .contacts)
    let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
    
    let predicate = CNContact.predicateForContactsInContainer(withIdentifier: store.defaultContainerIdentifier())
    let request = CNContactFetchRequest(keysToFetch: keysToFetch)
    request.predicate = predicate
    try store.enumerateContacts(with: request) { contact, _ in
      let name = "\(contact.givenName) \(contact.familyName)"
      let phoneNumber = contact.phoneNumbers
        .filter { $0.label == CNLabelPhoneNumberMobile }
        .map { $0.value.stringValue }
        .first
      if let phoneNumber = phoneNumber {
        mutable.append(.init(name: name, phoneNumber: phoneNumber))
      }
    }
    withcheck
    return mutable
  }
}
