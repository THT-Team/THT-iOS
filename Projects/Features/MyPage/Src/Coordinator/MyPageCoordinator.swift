//
//  MyPageCoordinator.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import Core
import DSKit
import PhotosUI
import Domain

public final class MyPageCoordinator: BaseCoordinator {
  public var finishFlow: (() -> Void)?

  private let factory: MyPageDependency

  init(viewControllable: ViewControllable,
       factory: MyPageDependency) {
    self.factory = factory
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    homeFlow()
  }
}

extension MyPageCoordinator: MyPageCoordinating {

  public func homeFlow() {
    let (vm, vc) = factory.makeMyPageHome()
    vm.onSetting = { [weak self] user in
      self?.runMySettingFlow(user)
    }
    vm.onEditNickname = { [weak self] nickname in
      self?.editNicknameFlow(nickname: nickname)
    }
    vm.onEditInfo = { [weak self] model in
      self?.sectionFlow(model)
    }
    vm.onPhotoEdit = { [weak self] handler in
      let alert = TFAlertBuilder.makePhotoEditAlert(handler)
      alert.modalTransitionStyle = .crossDissolve
      self?.viewControllable.present(alert, animated: true)
    }
    let picker = PHPickerControllable()
    
    vm.onPhotoCell = { [weak self] index, handler in
      picker.handelr = handler
      self?.viewControllable.present(picker, animated: true)
    }
    self.viewControllable.setViewControllers([vc])
  }

  public func editNicknameFlow(nickname: String) {
    var (vm, vc) = factory.editNicknameFlow(nickname: nickname)
    vm.onComplete = { [weak self] in
      self?.viewControllable.popToRootViewController(animated: true)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func editIntroduceFlow(introduce: String) {
    var (vm, vc) = factory.editIntroduceFlow(introduce: introduce)
    vm.onComplete = { [weak self] in
      self?.viewControllable.popToRootViewController(animated: true)
    }
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func editphotoFlow() {

  }

  public func editPreferGenderBottomSheetFlow(preferGender: Gender) {
    var (vm, vc) = factory.makeGenderSheet(gender: preferGender)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 353.adjustedH, animated: true)
  }

  public func editHeightBottomSheetFlow(height: Int) {
    var (vm, vc) = factory.editHeightBottomSheetFlow(height: height)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 350, animated: true)
  }
  
  public func editSmokingBottomSheetFlow(frequency: Frequency) {
    var (vm, vc) = factory.editSmokingBottomSheetFlow(frequency: frequency)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 273.adjustedH, animated: true)
  }
  
  public func editDrinkingBottomSheetFlow(frequency: Frequency) {
    var (vm, vc) = factory.editDrinkingBottomSheetFlow(frequency: frequency)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 273.adjustedH, animated: true)
  }
  
  public func editReligionBottomSheetFlow(religion: Religion) {
    var (vm, vc) = factory.editReligionBottomSheetFlow(religion: religion)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 350.adjustedH, animated: true)
  }
  
  public func editInterestBottomSheetFlow(interest: [EmojiType]) {
    var (vm, vc) = factory.editInterestBottomSheetFlow(interest: interest)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 600, animated: true)
  }
  public func editIdealTypeBottomSheetFlow(ideals: [EmojiType]) {
    var (vm, vc) = factory.editIdealTypeBottomSheetFlow(ideals: ideals)
    vm.onDismiss = { [weak self] in
      self?.viewControllable.dismiss()
    }
    self.viewControllable.presentMediumBottomSheet(vc, height: 600, animated: true)
  }
}

// MARK: Navigate Action

extension MyPageCoordinator {

  private func sectionFlow(_ section: MyPageSection) {
    switch section {
    case .birthday:
      break
    case .introduction(let introduce):
      editIntroduceFlow(introduce: introduce)
    case let .height(height):
      editHeightBottomSheetFlow(height: height)
    case let .preferGender(gender):
      editPreferGenderBottomSheetFlow(preferGender: gender)
    case let .smoking(frequency):
      editSmokingBottomSheetFlow(frequency: frequency)
    case let .drinking(frequency):
      editDrinkingBottomSheetFlow(frequency: frequency)
    case let .religion(religion):
      editReligionBottomSheetFlow(religion: religion)
    case let .interest(interest):
      editInterestBottomSheetFlow(interest: interest)
    case let .idealType(ideals):
      editIdealTypeBottomSheetFlow(ideals: ideals)
    default: break
    }
  }
}

// MARK: MySetting

extension MyPageCoordinator {

  public func runMySettingFlow(_ user: User) {
    let coordinator = factory.build(rootViewControllable: self.viewControllable, user: user)

    coordinator.finishFlow = { [weak self, weak coordinator] option in
      self?.detachChild(coordinator)
    }

    self.attachChild(coordinator)
    coordinator.settingHomeFlow(user)
  }
}
