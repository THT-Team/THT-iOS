//
//  SignUpCoordinator.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import SignUpInterface

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
    let vm = TagPickerViewModel(action: .nextAtInterest([]))
    vm.delegate = self
    let vc = InterestPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func IdealTypeTagPickerFlow() {
    let vm = TagPickerViewModel(action: .nextAtIdealType([]))
    vm.delegate = self

    let vc = IdealTypePickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func IntroductFlow() {
    let vm = IntroduceInputViewModel()
    vm.delegate = self

    let vc = IntroduceInputViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func alcoholTobaccoFlow() {
    let vm = AlcoholTobaccoPickerViewModel()
    vm.delegate = self

    let vc = AlcoholTobaccoPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func religionFlow() {
    let vm = ReligionPickerViewModel()
    vm.delegate = self
    let vc = ReligionPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
}


extension SignUpCoordinator: SignUpCoordinatingActionDelegate {
  func invoke(_ action: SignUpCoordinatingAction) {
    switch action {
    case .phoneNumber:
//      phoneNumberFlow()
        IntroductFlow()
    case .nextAtPhoneNumber:
      emailFlow()
    case .nextAtEmail:
      policyFlow()
    case let .nextAtPolicy(agreement):
      nicknameFlow()
    case .nextAtNickname:
      genderPickerFlow()

    case let .birthdayTap(birthDay, listener):
      pickerBottomSheetFlow(.date(date: birthDay), listener: listener)
    case .nextAtGender:
      preferGenderPickerFlow()

    case .nextAtPreferGender:
      photoFlow()

    case let .photoCellTap(_, listener):
      photoPickerFlow(delegate: listener)
    case .nextAtPhoto:
      heightPickerFlow()

    case let .heightLabelTap(height, listener):
      singlePickerBottomSheetFlow(.text(text: String(height)), listener: listener)

    case .nextAtHeight:
      alcoholTobaccoFlow()

    case .nextAtAlcoholTobacco:
      religionFlow()

    case let .nextAtReligion(religion):
      InterestTagPickerFlow()
    case let .nextAtInterest(tags):
      IdealTypeTagPickerFlow()

    case let .nextAtIdealType(tags):
      IntroductFlow()
    case let .nextAtIntroduce(introduce):
      print(introduce)

    default: break
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
