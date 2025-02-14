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
import Domain

protocol SignUpCoordinatingActionDelegate: AnyObject {
  func invoke(_ action: SignUpCoordinatingAction, _ pendingUser: PendingUser)
}

public final class SignUpCoordinator: BaseCoordinator, SignUpCoordinating {
  public func start(_ userInfo: SNSUserInfo) {

    guard let phoneNumber = userInfo.phoneNumber else { return }

    guard let email = userInfo.email else {
      emailFlow(user: initPendingUser(phoneNumber: phoneNumber))
      return
    }
    policyFlow(user: initPendingUser(with: userInfo))
  }

  @Injected private var useCase: SignUpUseCaseInterface
  @Injected private var locationUseCase: LocationUseCaseInterface
  @Injected private var userDomainUseCase: UserDomainUseCaseInterface

  public weak var delegate: SignUpCoordinatorDelegate?
  public var finishFlow: ((FinishSignUpOption) -> Void)?

//  // TODO: UserDefaultStorage이용해서 어느 화면 띄워줄건지 결정

  private func initPendingUser(phoneNumber: String) -> PendingUser {
    var pendingUser = UserDefaultRepository.shared.fetchModel(for: .pendingUser, type: PendingUser.self) ?? PendingUser(phoneNumber: phoneNumber)
    pendingUser.phoneNumber = phoneNumber
    return pendingUser
  }

  private func initPendingUser(with snsUser: SNSUserInfo) -> PendingUser {
    PendingUser(snsUser)
  }

  public func locationFlow(user: PendingUser) {
    let viewModel = LocationInputViewModel(useCase: useCase, locationUseCase: locationUseCase, pendingUser: user)
    viewModel.delegate = self
    let viewController = LocationInputViewController(viewModel: viewModel)
    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func emailFlow(user: PendingUser) {
    let viewModel = EmailInputViewModel(useCase: useCase, pendingUser: user)
    viewModel.delegate = self

    let viewController = EmailInputViewController (viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func nicknameFlow(user: PendingUser) {
    let viewModel = NicknameInputViewModel(useCase: useCase, pendingUser: user)
    viewModel.delegate = self

    let viewController = NicknameInputViewController(viewModel: viewModel)
    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func policyFlow(user: PendingUser) {
    let viewModel = PolicyAgreementViewModel(useCase: useCase, pendingUser: user)
    viewModel.delegate = self

    let viewController = PolicyAgreementViewController(viewModel: viewModel)

    self.viewControllable.pushViewController(viewController, animated: true)
  }

  public func genderPickerFlow(user: PendingUser) {
    let vm = GenderPickerViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self
    let vc = GenderPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func preferGenderPickerFlow(user: PendingUser) {
    let vm = PreferGenderPickerViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self
    let vc = PreferGenderPickerViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func photoFlow(user: PendingUser) {
    let vm = PhotoInputViewModel(useCase: useCase, pendingUser: user)
    let picker = PHPickerControllable()
    vm.onFetchPhoto = { [weak self] handler in
      picker.handelr = handler
      self?.viewControllable.present(picker, animated: true)
    }
    vm.onPhotoEdit = { [weak self] handler in
      let alert = TFAlertBuilder.makePhotoEditAlert(handler)
      alert.modalTransitionStyle = .crossDissolve
      self?.viewControllable.present(alert, animated: true)
    }
    vm.onNext = { [weak self] user in
      self?.heightFlow(user: user)
    }
    let vc = PhotoInputViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func heightFlow(user: PendingUser) {
    let vm = HeightPickerViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self
    let vc = HeightPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func interestFlow(user: PendingUser) {
    let vm = InterestPickerVM(useCase: useCase, pendingUser: user, userDomainUseCase: userDomainUseCase)
    vm.delegate = self
    let vc = InterestPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func drinkAndSmokeFlow(user: SignUpInterface.PendingUser) {
    let vm = AlcoholTobaccoPickerViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self

    let vc = AlcoholTobaccoPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func religionFlow(user: SignUpInterface.PendingUser) {
    let vm = ReligionPickerViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self
    let vc = ReligionPickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func introduceFlow(user: SignUpInterface.PendingUser) {
    let vm = IntroduceInputViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self

    let vc = IntroduceInputViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func blockUserFlow(user: SignUpInterface.PendingUser) {
    let vm = UserContactViewModel(useCase: useCase, pendingUser: user)
    vm.delegate = self
    let vc = UserContactViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func signUpCompleteFlow(user: SignUpInterface.PendingUser) {
    let vm = SignUpCompleteViewModel(useCase: useCase, pendingUser: user)

    vm.onNext = { [weak self] in
      self?.finishFlow?(.complete)
    }
    let vc = SignUpCompleteViewController(viewModel: vm)
    
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func idealTypeFlow(user: PendingUser) {
    let vm = IdealTypePickerVM(useCase: useCase, pendingUser: user, userDomainUseCase: userDomainUseCase)
    vm.delegate = self
    let vc = IdealTypePickerViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
  
  func webViewFlow(listener: WebViewDelegate) {
    let vc = PostCodeWebViewController()
    vc.delegate = listener
    vc.modalPresentationStyle = .overFullScreen
    self.viewControllable.present(vc, animated: true)
  }

  private func agreementWebViewFlow(url: URL) {
    let vc = TFWebViewController(url: url)
    let nav = NavigationViewControllable(rootViewControllable: vc)
    self.viewControllable.present(nav, animated: true)
  }
}


extension SignUpCoordinator: SignUpCoordinatingActionDelegate {
  func invoke(_ action: SignUpCoordinatingAction, _ pendingUser: PendingUser) {
    switch action {
    case let .loginType(snsType):
      print(snsType)
    case .backAtEmail:
      self.finishFlow?(.back)
    case .nextAtEmail:
      policyFlow(user: pendingUser)
    case .nextAtPolicy:
      nicknameFlow(user: pendingUser)
    case .nextAtNickname:
      genderPickerFlow(user: pendingUser)
    case let .birthdayTap(birthDay, listener):
      pickerBottomSheetFlow(.date(date: birthDay), listener: listener)
    case .nextAtGender:
      preferGenderPickerFlow(user: pendingUser)
    case .nextAtPreferGender:
      photoFlow(user: pendingUser)
    case let .photoCellTap(_, handler):
//      photoPickerFlow(handler: handler)
      break
    case .nextAtPhoto:
      heightFlow(user: pendingUser)

    case let .heightLabelTap(height, listener):
      singlePickerBottomSheetFlow(.text(text: String(height)), listener: listener)

    case .nextAtHeight:
      drinkAndSmokeFlow(user: pendingUser)

    case .nextAtAlcoholTobacco:
      religionFlow(user: pendingUser)

    case .nextAtReligion:
      interestFlow(user: pendingUser)
    case .nextAtInterest:
      idealTypeFlow(user: pendingUser)

    case .nextAtIdealType:
      introduceFlow(user: pendingUser)
    case .nextAtIntroduce:
      locationFlow(user: pendingUser)
    case let .webViewTap(listener):
      webViewFlow(listener: listener)
    case .nextAtLocation:
      blockUserFlow(user: pendingUser)
    case .nextAtHideFriends:
      signUpCompleteFlow(user: pendingUser)
    case .nextAtSignUpComplete:
      finishFlow?(.complete)
    case let .agreementWebView(url):
      agreementWebViewFlow(url: url)

    case let .photoEditOrDeleteAlert(listener):
      showTopBottomAlert(listener)
    }
  }
}

extension SignUpCoordinator {
  public func showTopBottomAlert(_ listener: TopBottomAlertListener) {
    let alert = TFAlertBuilder.makePhotoEditOrDeleteAlert(listener: listener)
    alert.modalTransitionStyle = .crossDissolve
    self.viewControllable.present(alert, animated: true)
  }
}

extension SignUpCoordinator: BottomSheetActionDelegate {
  public func sheetInvoke(_ action: BottomSheetViewAction) {
    if case .onDismiss = action {
      self.viewControllable.uiController.dismiss(animated: true)
    }
  }
}
