//
//  MyPageUseCase.swift
//  MyPageInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import SignUpInterface
import RxSwift

public final class MyPageUseCase: MyPageUseCaseInterface {
  
  private let repository: MyPageRepositoryInterface
  private let contactsService: ContactServiceType

  public init(repository: MyPageRepositoryInterface, contactsService: ContactServiceType) {
    self.repository = repository
    self.contactsService = contactsService
  }
  
  public func fetchUser() -> Single<User> {
    repository.fetchUser()
  }

  public func fetchUserContacts() -> Single<Int> {
    repository
      .fetchUserContacts()
  }

  public func updateUserContact() -> Single<Int> {
    self.contactsService.fetchContact()
      .flatMap { [unowned self] contacts in
        self.repository.updateUserContacts(contacts: contacts)
      }
  }
}

