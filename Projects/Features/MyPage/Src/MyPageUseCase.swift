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

import Core

public final class MyPageUseCase: MyPageUseCaseInterface {

  private let repository: MyPageRepositoryInterface
  private let contactsService: ContactServiceType

  public init(repository: MyPageRepositoryInterface, contactsService: ContactServiceType) {
    self.repository = repository
    self.contactsService = contactsService
  }

  public func fetchAlarmSetting() -> AlarmSetting {
    guard let alarmSetting = UserDefaultRepository.shared.fetchModel(for: .alarmSetting, type: AlarmSetting.self) else {
      return AlarmSettingFactory.createDefaultAlarmSetting()
    }
    return alarmSetting
  }

  public func saveAlarmSetting(_ alarmSetting: AlarmSetting) -> Completable {
    repository.updateAlarmSetting(alarmSetting.settings)
      .andThen(.create { observer in
        UserDefaultRepository.shared.saveModel(alarmSetting, key: .alarmSetting)
        observer(.completed)
        return Disposables.create()
      })
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

  public func updateLocation(_ location: LocationReq) -> Single<Void> {
    .just(())
  }
}

