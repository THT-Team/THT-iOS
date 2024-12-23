//
//  MyPageCoordinator.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import SignUpInterface
import AuthInterface
import Core
import DSKit
import PhotosUI
import Domain

public final class MyPageCoordinator: BaseCoordinator {

  @Injected var myPageUseCase: MyPageUseCaseInterface
  @Injected var userDomainUseCase: UserDomainUseCaseInterface

  private let mySettingBuildable: MySettingBuildable
  private var mySettingCoordinator: MySettingCoordinating?

  public var finishFlow: (() -> Void)?

  private let userStore: UserStore

  init(viewControllable: ViewControllable,
       mySettingBuildable: MySettingBuildable) {
    self.mySettingBuildable = mySettingBuildable

    userStore = UserStore()
    super.init(viewControllable: viewControllable)
  }

  public override func start() {
    homeFlow()
  }
}

extension MyPageCoordinator: MyPageCoordinating {

  public func homeFlow() {
    let viewModel = MyPageHomeViewModel(myPageUseCase: myPageUseCase, userStore: userStore)
    viewModel.delegate = self

    let viewController = MyPageHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }

  public func editNicknameFlow(nickname: String) {
    let vm = NicknameEditVM(useCase: myPageUseCase, nickname: nickname, userStore: userStore)
    vm.delegate = self
    let vc = NicknameEditVC(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func editIntroduceFlow(introduce: String) {
    let vm = IntroduceEditVM(useCase: myPageUseCase, introduce: introduce, userStore: userStore)
    vm.delegate = self
    let vc = IntroduceEditVC(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func editphotoFlow() {

  }

  public func editPreferGenderBottomSheetFlow(prefetGender: Gender, listener: BottomSheetListener) {
    let vm = PreferGenderVM(initialValue: .text(text: prefetGender.rawValue), useCase: myPageUseCase, userStore: userStore)
    vm.delegate = self
    vm.listener = listener
    let vc = PreferGenderVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 353.adjustedH, animated: true)
  }

  public func editHeightBottomSheetFlow(height: Int, listener: BottomSheetListener) {
    let vm = HeightEditVM(initialValue: .text(text: "\(height)"), useCase: myPageUseCase, userStore: userStore)
    vm.delegate = self
    vm.listener = listener
    let vc = HeightEditVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 350, animated: true)
  }
  
  public func editSmokingBottomSheetFlow(frequency: Frequency, listener: BottomSheetListener) {
    let vm = SmokingEditVM(initialValue: .text(text: frequency.rawValue), useCase: myPageUseCase,
    userStore: userStore)
    vm.delegate = self
    vm.listener = listener
    let vc = SmokingEditVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 273.adjustedH, animated: true)
  }
  
  public func editDrinkingBottomSheetFlow(frequency: Frequency, listener: BottomSheetListener) {
    let vm = DrinkingEditVM(initialValue: .text(text: frequency.rawValue), useCase: myPageUseCase,
    userStore: userStore)
    vm.delegate = self
    vm.listener = listener
    let vc = DrinkingEditVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 273.adjustedH, animated: true)
  }
  
  public func editReligionBottomSheetFlow(religion: Religion, listener: BottomSheetListener) {
    let vm = ReligionEditVM(initialValue: .text(text: religion.rawValue), useCase: myPageUseCase,
    userStore: userStore)
    vm.delegate = self
    vm.listener = listener
    let vc = ReligionEditVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 350.adjustedH, animated: true)
  }
  
  public func editInterestBottomSheetFlow(interest: [EmojiType], listener: BottomSheetListener) {
    let initialValue = interest.reduce("") { $0 + ",\($1.idx)"}
    let vm = InterestEditVM(initialValue: .text(text: initialValue), useCase: userDomainUseCase, userStore: userStore)
    vm.delegate = self
    vm.listener = listener
    let vc = InterestEditVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 600, animated: true)
  }
  public func editIdealTypeBottomSheetFlow(ideals: [EmojiType], listener: BottomSheetListener) {
    let initialValue = ideals.reduce("") { $0 + ",\($1.idx)"}
    let vm = IdealEditVM(
      initialValue: .text(text: initialValue),
      useCase: userDomainUseCase,
      userStore: userStore
    )
    vm.delegate = self
    vm.listener = listener
    let vc = IdealEditVC(viewModel: vm)
    self.viewControllable.presentMediumBottomSheet(vc, height: 600, animated: true)
  }
}

// MARK: Navigate Action

extension MyPageCoordinator: MyPageCoordinatingActionDelegate {
  public func invoke(_ action: MyPageCoordinatingAction) {
    switch action {
    case let .setting(user):
      attachMySetting(user)

    // Cell 누르면 Section casting해서 넘겨줌
    case let .edit(section):
      sectionFlow(section)
    case let .editNickname(nickname):
      editNicknameFlow(nickname: nickname)

    case .popToRoot:
      self.viewControllable.popToRootViewController(animated: true)
      
    case let .photoCellTap(index: index, listener: listener):
      photoPickerFlow(delegate: listener)
    case let .photoEditOrDeleteAlert(listener):
      showTopBottomAlert(listener)
    default: break
    }

    func showTopBottomAlert(_ listener: TopBottomAlertListener) {
      let alert = TFAlertBuilder.makePhotoEditOrDeleteAlert(listener: listener)
      alert.modalTransitionStyle = .crossDissolve
      self.viewControllable.present(alert, animated: true)
    }
  }
  
  public func photoPickerFlow(delegate: PhotoPickerDelegate) {
    let picker = PHPickerControllable(delegate: delegate)
    self.viewControllable.present(picker, animated: true)
  }

  private func sectionFlow(_ section: MyPageSection) {
    switch section {
    case .birthday(let string):
      let vc = TFBaseViewController(nibName: nil, bundle: nil)
      self.viewControllable.presentBottomSheet(vc, animated: true)
    case .introduction(let introduce):
      editIntroduceFlow(introduce: introduce)
    case let .height(height, listener):
      editHeightBottomSheetFlow(height: height, listener: listener)
    case let .preferGender(gender, listener):
      editPreferGenderBottomSheetFlow(prefetGender: gender, listener: listener)
    case let .smoking(frequency, listener):
      editSmokingBottomSheetFlow(frequency: frequency, listener: listener)
    case let .drinking(frequency, listener):
      editDrinkingBottomSheetFlow(frequency: frequency, listener: listener)
    case let .religion(religion, listener):
      editReligionBottomSheetFlow(religion: religion, listener: listener)
    case let .interest(interest, listener):
      editInterestBottomSheetFlow(interest: interest, listener: listener)
    case let .idealType(ideals, listener):
      editIdealTypeBottomSheetFlow(ideals: ideals, listener: listener)
    default: break
    }
  }
}

// MARK: MySetting

extension MyPageCoordinator: MySettingCoordinatorDelegate {

  public func attachMySetting(_ user: User) {
    let coordinator = self.mySettingBuildable.build(rootViewControllable: self.viewControllable, user: user)

    coordinator.finishFlow = { [weak self, weak coordinator] option in
      guard let coordinator else { return }
      self?.detachChild(coordinator)
      switch option {
      case .finish: break
      case .toRoot:
        self?.finishFlow?()
      }
    }

    self.attachChild(coordinator)
    coordinator.settingHomeFlow(user)
  }
}


