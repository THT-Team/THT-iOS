////
////  SignUpCoordinator+Contacts.swift
////  SignUp
////
////  Created by kangho lee on 5/6/24.
////
//
//import Foundation
//import ContactsUI
//import SignUpInterface
//
//import Core
//
//public protocol UserContactPickerDelegate: CNContactPickerDelegate {
//  var listener: UserContactListener? { get }
//}
//
//public protocol UserContactListener: AnyObject {
//  func picker(didFinishPicking contacts: [UserFriendContactReq.Contact])
//}
//
//extension SignUpCoordinator {
//  public func presentContactsUI(delegate: UserContactPickerDelegate) {
//    let picker = CNContactPickerViewController()
//    picker.delegate = delegate
//    
//    self.viewControllable.present(picker, animated: true)
//  }
//}
//
//extension CNContactPickerViewController: ViewControllable {
//  public var uiController: UIViewController { return self }
//}
//
//public class UserContactPickerDelegator: NSObject, UserContactPickerDelegate {
//  public weak var listener: UserContactListener?
//  
//  init(listener: UserContactListener) {
//    self.listener = listener
//  }
//  
//  deinit {
//    print("deinit: ContactsPickerDelegate!")
//  }
//  
//  public func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
//    var mutableContacts: [UserFriendContactReq.Contact] = []
//    
//    let store = CNContactStore()
//    let keysToFetch = [
//      CNContactGivenNameKey,
//      CNContactFamilyNameKey,
//      CNContactPhoneNumbersKey,
//      CNContactOrganizationNameKey,
//    ] as [CNKeyDescriptor]
//    
//    contacts.forEach { contact in
//      do {
//        let predicate = CNContact.predicateForContacts(withIdentifiers: [contact.identifier])
//        guard let contact = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch).first
//        else { return }
//        let name: String
//        
//        if contact.familyName.count == 0 && contact.givenName.count == 0 {
//          name = "\(contact.organizationName)"
//        } else {
//          name = "\(contact.familyName)\(contact.givenName)"
//        }
//        
//        if let phone = contact.phoneNumbers.first {
//          let phoneNumber = "\(phone.value.stringValue)"
//          mutableContacts.append(.init(name: name, phoneNumber: phoneNumber))
//        }
//        
//      } catch {
//        print("Failed to fetch, error: \(error)")
//      }
//    }
//    
//    listener?.picker(didFinishPicking: mutableContacts)
//    picker.dismiss()
//  }
//
//}
