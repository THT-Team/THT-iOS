//
//  ContactService.swift
//  Data
//
//  Created by Kanghos on 5/12/24.
//

import Foundation
import RxSwift
import Contacts
import Domain

enum ContactError: Error {
  case fetchError(message: String)
}

public final class ContactService: ContactServiceType {

  public init() { }
  public func fetchContact() -> Single<[ContactType]> {
    return Single.create { [unowned self] single in
      self.fetchContacts { result in
        switch result {
        case .success(let contacts):
          single(.success(contacts.toValidate()))
        case .failure(let error):
          single(.failure(error))
        }
      }
      return Disposables.create()
    }
  }

  private func fetchContacts(completion: @escaping (Result<[ContactType], ContactError>) -> Void) {
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { granted, error in
      guard granted == true, error == nil else {
        return
      }

      let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
      let request = CNContactFetchRequest(keysToFetch: keys)
      var contacts: [ContactType] = []

      do {
        try store.enumerateContacts(with: request) { contact, _ in
          let name = contact.givenName
          let phoneNumber = contact.phoneNumbers.first?.value.stringValue ?? ""
          let contact = ContactType(name: name, phoneNumber: phoneNumber)
          contacts.append(contact)
        }
        completion(.success(contacts))
      } catch {
        completion(.failure(.fetchError(message: error.localizedDescription)))
      }
    }
  }
}

extension Array where Element == ContactType {
  func toValidate() -> [Element] {
    self.map { contact in
      let phoneNumber = contact.phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
      return ContactType(name: contact.name, phoneNumber: phoneNumber)
    }
  }
}
