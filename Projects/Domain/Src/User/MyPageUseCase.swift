//
//  MyPageUseCase.swift
//  MyPageInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import RxSwift

import Core

public final class MyPageUseCase: MyPageUseCaseInterface {

  public func createSettingMenu(user: User) -> [SectionModel<MySetting.MenuItem>] {

    SectionGenerator.createMySettingSections(
      user: user,
      list: UserDefaultRepository.shared.fetchModel(for: .sign_up_info, type: UserSignUpInfoRes.self)?.typeList ?? [])
  }

  private let repository: MyPageRepositoryInterface
  private let authService: AuthServiceType
  private let contactsService: ContactServiceType
  private let imageService: ImageServiceType

  public init(
    repository: MyPageRepositoryInterface,
    contactsService: ContactServiceType,
    authService: AuthServiceType,
    imageService: ImageServiceType
  ) {
    self.repository = repository
    self.contactsService = contactsService
    self.authService = authService
    self.imageService = imageService
  }

  public func fetchAlarmSetting() -> AlarmSetting {
    guard let alarmSetting = UserDefaultRepository.shared.fetchModel(for: .alarmSetting, type: AlarmSetting.self) else {
      return AlarmSettingFactory.createDefaultAlarmSetting()
    }
    return alarmSetting
  }

  public func saveAlarmSetting(_ alarmSetting: AlarmSetting) -> Completable {
    repository.updateAlarmSetting(alarmSetting.settings)
      .flatMapCompletable {
        .create { observer in
          UserDefaultRepository.shared.saveModel(alarmSetting, key: .alarmSetting)
          observer(.completed)
          return Disposables.create()
        }
      }
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
    repository.updateLocation(location)
  }

  public func logout() -> Single<Void> {
    removeUser()
    return repository.logout()
      .map { _ in }
  }

  public func withdrawal(reason: String, feedback: String) -> RxSwift.Single<Void> {
    removeUser()
    return .just(())
  }

  private func removeUser() {
    authService.clearToken()
    UserDefaultRepository.shared.removeUser()
  }
}

// MARK: Update
extension MyPageUseCase {
  public func updateNickname(_ nickname: String) -> Single<Void> {
    repository.updateNickname(nickname)
  }

  public func checkNickname(_ nickname: String) -> Single<Bool> {
    if !nickname.isEmpty && nickname.count > 5 {
      return .just(true)
    }
    return .error(MyPageError.invalidNickname)
  }

  public func updateIntroduce(_ introduce: String) -> Single<Void> {
    repository.updateIntroduction(introduce)
  }

  public func updateHeight(_ height: Int) -> Single<Void> {
    repository.updateHeight(height)
  }

  public func updatePreferGender(_ gender: Gender) -> Single<Void> {
    repository.updatePreferGender(gender)
  }

  public func updateSmoking(_ frequency: Frequency) -> Single<Void> {
    repository.updateSmoking(frequency)
  }

  public func updateDrinking(_ frequency: Frequency) -> Single<Void> {
    repository.updateDrinking(frequency)
  }

  public func updateReligion(_ religion: Religion) -> Single<Void> {
    repository.updateReligion(religion)
  }

  public func updateInterest(_ interest: [EmojiType]) -> Single<Void> {
    repository.updateInterests(interest)
  }

  public func updateIdealType(_ idealType: [EmojiType]) -> Single<Void> {
    repository.updateIdealType(idealType)
  }

  public func updatePhoneNumber(_ phoneNumber: String) -> RxSwift.Single<Void> {
    repository.updatePhoneNumber(phoneNumber)
  }

  public func updateEmail(_ email: String) -> RxSwift.Single<Void> {
    repository.updateEmail(email)
  }

  public func updateProfilePhoto(_ photos: [UserProfilePhoto]) -> Single<Void> {
    repository.updateProfilePhotos(photos)
  }
}

extension MyPageUseCase {
  public func updateImage(_ data: Data, priority: Int) -> Single<UserProfilePhoto> {
    imageService.uploadImage(imageData: data, bucket: .profile)
      .map { UserProfilePhoto(url: $0, priority: priority) }
  }

  public func processImage(_ result: PhotoItem) -> Single<Data> {
    imageService.bind(result, imageSize: .profile)
  }
}
