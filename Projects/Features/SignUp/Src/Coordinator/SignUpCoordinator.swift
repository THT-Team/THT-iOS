//
//  SignUpCoordinator.swift
//  SignUpInterface
//
//  Created by Kanghos on 2023/12/06.
//

import Foundation

import Core
import SignUpInterface
import AuthInterface
import DSKit

protocol SignUpCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: SignUpCoordinatingAction)
}

public final class SignUpCoordinator: BaseCoordinator, SignUpCoordinating {
  
  @Injected private var useCase: SignUpUseCaseInterface
  @Injected private var userInfoUseCase: UserInfoUseCaseInterface

  public weak var delegate: SignUpCoordinatorDelegate?

  // TODO: UserDefaultStorage이용해서 어느 화면 띄워줄건지 결정
  public override func start() {
    replaceWindowRootViewController(rootViewController: viewControllable)
    emailFlow()
  }

  public func locationFlow() {
    let viewModel = LocationInputViewModel(useCase: useCase, userInfoUseCase: self.userInfoUseCase)
    viewModel.delegate = self
    let viewController = LocationInputViewController(viewModel: viewModel)
    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func finishFlow() {
    self.delegate?.detachSignUp(self)
  }

  public func emailFlow() {
    let viewModel = EmailInputViewModel(userInfoUseCase: self.userInfoUseCase)
    viewModel.delegate = self

    let viewController = EmailInputViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func nicknameFlow() {
    let viewModel = NicknameInputViewModel(useCase: useCase, userInfoUseCase: self.userInfoUseCase)
    viewModel.delegate = self

    let viewController = NicknameInputViewController(viewModel: viewModel)
    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func policyFlow() {
    let viewModel = PolicyAgreementViewModel(useCase: self.useCase, userInfoUseCase: self.userInfoUseCase)
    viewModel.delegate = self

    let viewController = PolicyAgreementViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func genderPickerFlow() {
    let vm = GenderPickerViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self
    let vc = GenderPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func preferGenderPickerFlow() {
    let vm = PreferGenderPickerViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self
    let vc = PreferGenderPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func photoFlow() {
    let vm = PhotoInputViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self
    let vc = PhotoInputViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func heightPickerFlow() {
    let vm = HeightPickerViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self
    let vc = HeightPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func InterestTagPickerFlow() {
    let vm = TagPickerViewModel(useCase: useCase, userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self
    let vc = InterestPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func IdealTypeTagPickerFlow() {
    let vm = IdealTypeTagPickerViewModel(useCase: useCase, userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self

    let vc = IdealTypePickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func IntroductFlow() {
    let vm = IntroduceInputViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self

    let vc = IntroduceInputViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func alcoholTobaccoFlow() {
    let vm = AlcoholTobaccoPickerViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self

    let vc = AlcoholTobaccoPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func religionFlow() {
    let vm = ReligionPickerViewModel(userInfoUseCase: self.userInfoUseCase)
    vm.delegate = self
    let vc = ReligionPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  func webViewFlow(listener: WebViewDelegate) {
    let vc = PostCodeWebViewController()
    vc.delegate = listener
    vc.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(vc, animated: true)
  }
  
  func blockUserFriendContactFlow() {
    let vm = UserContactViewModel(useCase: self.useCase)
    vm.delegate = self
    let vc = UserContactViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  func signUpCompleteFlow(_ contacts: [ContactType]) {
    let vm = SignUpCompleteViewModel(useCase: self.useCase, userInfoUseCase: userInfoUseCase, contacts: contacts)
    vm.delegate = self
    let vc = SignUpCompleteViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  private func agreementWebViewFlow(url: URL) {
    let vc = TFWebViewController(url: url)
    let nav = NavigationViewControllable(rootViewControllable: vc)
    self.viewControllable.present(nav, animated: true)
  }
}


extension SignUpCoordinator: SignUpCoordinatingActionDelegate {
  func invoke(_ action: SignUpCoordinatingAction) {
    switch action {
    case let .loginType(snsType):
      print(snsType)
    case .nextAtPhoneNumber:
      emailFlow()
    case .nextAtEmail:
      policyFlow()
    case .nextAtPolicy:
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

    case .nextAtReligion:
      InterestTagPickerFlow()
    case .nextAtInterest:
      IdealTypeTagPickerFlow()

    case .nextAtIdealType:
      IntroductFlow()
    case .nextAtIntroduce:
      locationFlow()
    case let .webViewTap(listener):
      webViewFlow(listener: listener)
    case .nextAtLocation:
      blockUserFriendContactFlow()
    case let .nextAtHideFriends(contacts):
      signUpCompleteFlow(contacts)
    case .nextAtSignUpComplete:
      finishFlow()
    case let .agreementWebView(url):
      agreementWebViewFlow(url: url)
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
