//
//  SignUpCoordinator.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import SignUpInterface

enum SignUpCoordinatingAction {
  case nextAtNickname
  case nextAtGender
  case birthdayTap(birthday: Date, listener: BottomSheetListener)
  case heightLabelTap(height: Int, listener: BottomSheetListener)
  case nextAtPreferGender
  case nextAtPhoto
  case nextAtHeight
  case photoCellTap(index: Int, listener: PhotoPickerDelegate)
  case nextAtAlcoholTobacco
}

protocol SignUpCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: SignUpCoordinatingAction)
}

public final class SignUpCoordinator: BaseCoordinator, SignUpCoordinating {

  public weak var delegate: SignUpCoordinatorDelegate?

  //  private let store = UserStore()

  // TODO: UserDefaultStorage이용해서 어느 화면 띄워줄건지 결정
  public override func start() {
    replaceWindowRootViewController(rootViewController: self.viewControllable)

    rootFlow()
  }

  public func rootFlow() {
    let viewModel = SignUpRootViewModel()
    viewModel.delegate = self

    let viewController = SignUpRootViewController()
    viewController.viewModel = viewModel

    self.viewControllable.setViewControllers([viewController])
  }

  public func finishFlow() {
    self.delegate?.detachSignUp(self)
  }

  public func emailFlow() {
    let viewModel = EmailInputViewModel()
    viewModel.delegate = self

    let viewController = EmailInputViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func nicknameFlow() {
    let viewModel = NicknameInputViewModel()
    viewModel.delegate = self

    let viewController = NicknameInputViewController(viewModel: viewModel)
    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func policyFlow() {
    let viewModel = PolicyAgreementViewModel()
    viewModel.delegate = self

    let viewController = PolicyAgreementViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func phoneNumberFlow() {
    let viewModel = PhoneCertificationViewModel()
    viewModel.delegate = self

    let viewController = PhoneCertificationViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func genderPickerFlow() {
    let vm = GenderPickerViewModel()
    vm.delegate = self
    let vc = GenderPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func preferGenderPickerFlow() {
    let vm = PreferGenderPickerViewModel()
    vm.delegate = self
    let vc = PreferGenderPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func photoFlow() {
    let vm = PhotoInputViewModel()
    vm.delegate = self
    let vc = PhotoInputViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func heightPickerFlow() {
    let vm = HeightPickerViewModel()
    vm.delegate = self
    let vc = HeightPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func InterestTagPickerFlow() {
    let vm = InterestTagPickerViewModel()
    vm.delegate = self
    let vc = InterestPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension SignUpCoordinator: SignUpRootDelegate {
  func toPhoneButtonTap() {
    InterestTagPickerFlow()
    //    phoneNumberFlow()
  }
}

extension SignUpCoordinator: PhoneCertificationDelegate {
  func finishAuth() {
    emailFlow()
  }
}

extension SignUpCoordinator: EmailInputDelegate {
  func emailNextButtonTap() {
    policyFlow()
  }
}

extension SignUpCoordinator: PolicyAgreementDelegate {
  func policyNextButtonTap() {
    nicknameFlow()
  }
}

extension SignUpCoordinator: NicknameInputDelegate {
  func nicknameNextButtonTap() {
    genderPickerFlow()
  }
}

extension SignUpCoordinator: SignUpCoordinatingActionDelegate {
  func invoke(_ action: SignUpCoordinatingAction) {
    if case let .birthdayTap(birthDay, listener) = action {
      pickerBottomSheetFlow(.date(date: birthDay), listener: listener)
    }

    if case let .heightLabelTap(height, listener) = action {
      singlePickerBottomSheetFlow(.text(text: String(height)), listener: listener)
    }
    if case .nextAtGender = action {
      preferGenderPickerFlow()
    }
    if case .nextAtPreferGender = action {
      photoFlow()
    }

    if case let .photoCellTap(_, listener) = action {
      photoPickerFlow(delegate: listener)
    }


  }
}

extension SignUpCoordinator: BottomSheetActionDelegate {
  public func sheetInvoke(_ action: BottomSheetViewAction) {
    if case .onDismiss = action {
      self.viewControllable.uiController.dismiss(animated: true)
    }
  }
}
