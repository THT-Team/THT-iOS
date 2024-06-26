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
  enum Key: String {
    case alarmSetting
  }

  private let repository: MyPageRepositoryInterface
  @CodableStorage<AlarmSetting>(key: Key.alarmSetting.rawValue, defaultValue: nil) private var _alarmSetting
  private let contactsService: ContactServiceType

  public init(repository: MyPageRepositoryInterface, contactsService: ContactServiceType) {
    self.repository = repository
    self.contactsService = contactsService
  }

  public func fetchAlarmSetting() -> AlarmSetting {
    _alarmSetting ?? .defaultSetting
  }

  public func saveAlarmSetting(_ alarmSetting: AlarmSetting) -> Completable {
    repository.updateAlarmSetting(alarmSetting.settings)
      .andThen(.create { [weak self] observer in
        self?._alarmSetting = alarmSetting
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

