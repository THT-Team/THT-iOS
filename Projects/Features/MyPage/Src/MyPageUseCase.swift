//
//  MyPageUseCase.swift
//  MyPageInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import SignUpInterface
import AuthInterface
import RxSwift
import Domain

import Core

public final class MyPageUseCase: MyPageUseCaseInterface {
  
  public func createSettingMenu(user: User) -> [MyPageInterface.SectionModel<MyPageInterface.MySetting.MenuItem>] {

    let userSignUpInfo = UserDefaultRepository.shared.fetchModel(for: .sign_up_info, type: UserSignUpInfoRes.self)
    
    return [
      createAccountMenus(signUpInfo: userSignUpInfo, user: user),
      SectionModel(
        type: .activity,
        items: [.item(MySetting.Item(title: "저장된 연락처 차단하기"))]),
      SectionModel(
        type: .location,
        items: [.item(MySetting.Item(title: "위치 설정", content: user.address))]),
      SectionModel(
        type: .notification,
        items: [.item(MySetting.Item(title: "알림 설정"))]),
      SectionModel(
        type: .support,
        items: [
          .linkItem(MySetting.LinkItem(title: "자주 묻는 질문", url: URL(string: "https://janechoi.notion.site/46bf7dbf13da4ca5a2e8dc44a5fb9236?pvs=4")!)),
          .item(MySetting.Item(title: "문의 및 피드백 보내기"))]),
      SectionModel(
        type: .law,
        items: [
          .linkItem(MySetting.LinkItem(title: "서비스 이용약관", url: URL(string: "https://janechoi.notion.site/526c51e9cb584f29a7c16251914bb3cb?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "개인정보 처리방침", url: URL(string: "https://janechoi.notion.site/5923a3c20259459bbacaff41290fc615?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "위치정보 이용약관", url: URL(string: "https://janechoi.notion.site/b45cf5f24d39494daf0a03b907a2ab7d?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "라이센스", url: URL(string: "https://janechoi.notion.site/c424bc053e7a479daa595d8bd69b0d1f?pvs=4")!)),
          .linkItem(MySetting.LinkItem(title: "사업자 정보", url: URL(string: "https://janechoi.notion.site/4f20dcc5c4084318910edfee3db5edb3?pvs=4")!))]),
      SectionModel(
        type: .accoutSetting,
        items: [.item(MySetting.Item(title: "계정 설정"))]),
    ]
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
      .flatMap { [unowned self] _ in
        return .just(())
      }
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

public enum MyPageError: Error, LocalizedError {
  case invalidNickname
  case duplicateNickname

  public var errorDescription: String? {
    switch self {
    case .invalidNickname:
      return "닉네임은 5자 이상 입력해주세요."
    case .duplicateNickname:
      return "중복된 닉네임입니다."
    }
  }
}


extension MyPageUseCase {
  private func createAccountMenus(signUpInfo: UserSignUpInfoRes?, user: User) -> SectionModel<MySetting.MenuItem> {
    let defaultSection = SectionModel<MySetting.MenuItem>(
      type: .account,
      items: [
        .item(MySetting.Item(title: "핸드폰 번호", content: user.phoneNumber)),
        .item(MySetting.Item(title: "이메일", content: user.email)),
      ])
    if let signUpInfo = UserDefaultRepository.shared.fetchModel(for: .sign_up_info, type: UserSignUpInfoRes.self), let signUpType =  signUpInfo.typeList.first {
      switch signUpType {
      case .kakao:
        return SectionModel(
          type: .account,
          items: [
            .item(MySetting.Item(title: "연동된 SNS", content: "카카오")),
          ])
      case .naver:
        return SectionModel(
          type: .account,
          items: [
            .item(MySetting.Item(title: "연동된 SNS", content: "네이버")),
          ])
      case .google:
        return SectionModel(
          type: .account,
          items: [
            .item(MySetting.Item(title: "연동된 SNS", content: "Google")),
          ])
      case .apple:
        return SectionModel(
          type: .account,
          items: [
            .item(MySetting.Item(title: "연동된 SNS", content: "Apple")),
          ])
      case .normal: return defaultSection
      }
    }
    return defaultSection
  }
}
