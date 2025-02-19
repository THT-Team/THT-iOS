//
//  MyPageFactory.swift
//  MyPage
//
//  Created by Kanghos on 12/23/24.
//

import Core
import DSKit
import MyPageInterface
import SignUpInterface
import AuthInterface
import Domain

public protocol MyPageFactoryType {
  func makeMyPageHome() -> (MyPageHomeViewModel, ViewControllable)
}

public typealias BottomSheetPresentable = (BottomSheetViewModelType, ViewControllable)

public protocol SignUpBottomSheetFactoryType {
  func makeGenderSheet(gender: Gender) -> BottomSheetPresentable
  func editHeightBottomSheetFlow(height: Int) -> BottomSheetPresentable
  func editSmokingBottomSheetFlow(frequency: Frequency) -> BottomSheetPresentable
  func editDrinkingBottomSheetFlow(frequency: Frequency) -> BottomSheetPresentable
  func editReligionBottomSheetFlow(religion: Religion) -> BottomSheetPresentable
  func editIdealTypeBottomSheetFlow(ideals: [EmojiType]) -> BottomSheetPresentable
  func editInterestBottomSheetFlow(interest: [EmojiType]) -> BottomSheetPresentable

  func editNicknameFlow(nickname: String) -> (NicknameEditVM, ViewControllable)
  func editIntroduceFlow(introduce: String) -> (IntroduceEditVM, ViewControllable)
}

public struct MyPageFactory: SignUpBottomSheetFactoryType {
  public let userStore: UserStore
  public let myPageUseCase: MyPageUseCaseInterface
  private let userDomainUseCase: UserDomainUseCaseInterface
  public let locationUseCase: LocationUseCaseInterface

  public var inquiryBuilder: any AuthInterface.InquiryBuildable

  public init(
    userStore: UserStore,
    myPageUseCase: MyPageUseCaseInterface,
    userDomainUseCase: UserDomainUseCaseInterface,
    locationUseCase: LocationUseCaseInterface,
    inquiryBuilder: any AuthInterface.InquiryBuildable) {
      self.userStore = userStore
      self.myPageUseCase = myPageUseCase
      self.userDomainUseCase = userDomainUseCase
      self.locationUseCase = locationUseCase
      self.inquiryBuilder = inquiryBuilder
    }

  public func makeGenderSheet(gender: Gender) -> BottomSheetPresentable {
    let vm = PreferGenderVM(initialValue: .text(text: gender.rawValue), useCase: myPageUseCase, userStore: userStore)
    let vc = PreferGenderVC(viewModel: vm)
    return (vm, vc)
  }

  public func editHeightBottomSheetFlow(height: Int) -> BottomSheetPresentable {
    let vm = HeightEditVM(initialValue: .text(text: "\(height)"), useCase: myPageUseCase, userStore: userStore)
    let vc = HeightEditVC(viewModel: vm)
    return (vm, vc)
  }

  public func editSmokingBottomSheetFlow(frequency: Frequency) -> BottomSheetPresentable {
    let vm = SmokingEditVM(initialValue: .text(text: frequency.rawValue), useCase: myPageUseCase,
                           userStore: userStore)
    let vc = SmokingEditVC(viewModel: vm)
    return (vm, vc)
  }

  public func editDrinkingBottomSheetFlow(frequency: Frequency) -> BottomSheetPresentable {
    let vm = DrinkingEditVM(initialValue: .text(text: frequency.rawValue), useCase: myPageUseCase,
                            userStore: userStore)
    let vc = DrinkingEditVC(viewModel: vm)
    return (vm, vc)
  }

  public func editReligionBottomSheetFlow(religion: Religion) -> BottomSheetPresentable {
    let vm = ReligionEditVM(initialValue: .text(text: religion.rawValue), useCase: myPageUseCase,
                            userStore: userStore)
    let vc = ReligionEditVC(viewModel: vm)
    return (vm, vc)
  }

  public func editInterestBottomSheetFlow(interest: [EmojiType]) -> BottomSheetPresentable {
    let initialValue = interest.reduce("") { $0 + ",\($1.idx)"}
    let vm = InterestEditVM(initialValue: .text(text: initialValue), useCase: userDomainUseCase, userStore: userStore)
    let vc = InterestEditVC(viewModel: vm)
    return (vm, vc)
  }
  public func editIdealTypeBottomSheetFlow(ideals: [EmojiType]) -> BottomSheetPresentable {
    let initialValue = ideals.reduce("") { $0 + ",\($1.idx)"}
    let vm = IdealEditVM(
      initialValue: .text(text: initialValue),
      useCase: userDomainUseCase,
      userStore: userStore
    )
    let vc = IdealEditVC(viewModel: vm)
    return (vm, vc)
  }

  public func editNicknameFlow(nickname: String) -> (NicknameEditVM, ViewControllable) {
    let vm = NicknameEditVM(useCase: myPageUseCase, nickname: nickname, userStore: userStore)
    let vc = NicknameEditVC(viewModel: vm)

    return (vm, vc)
  }

  public func editIntroduceFlow(introduce: String) -> (IntroduceEditVM, ViewControllable) {
    let vm = IntroduceEditVM(useCase: myPageUseCase, introduce: introduce, userStore: userStore)
    let vc = IntroduceEditVC(viewModel: vm)

    return (vm, vc)
  }
}

extension MyPageFactory: MyPageFactoryType {
  public func makeMyPageHome() -> (MyPageHomeViewModel, any ViewControllable) {
    let vm = MyPageHomeViewModel(myPageUseCase: myPageUseCase, userStore: userStore)
    let vc = MyPageHomeViewController(viewModel: vm)
    return (vm, vc)
  }
}

extension MyPageFactory: MySettingBuildable {
  public func build(rootViewControllable: (any ViewControllable), user: User) -> any MySettingCoordinating {
    MySettingCoordinator(viewControllable: rootViewControllable, factory: self)
  }
}
