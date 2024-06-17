//
//  MyPageCoordinator.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import Foundation

import MyPageInterface
import SignUpInterface
import Core

public final class MyPageCoordinator: BaseCoordinator {

  @Injected var myPageUseCase: MyPageUseCaseInterface
  @Injected var locationUseCase: LocationUseCaseInterface

  public weak var delegate: MyPageCoordinatorDelegate?
  
  public override func start() {
    homeFlow()
  }
}

extension MyPageCoordinator: MyPageCoordinating {
  public func testFlow() {
    let vc = TagsPickerViewController(nibName: nil, bundle: nil)
    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func homeFlow() {
    let viewModel = MyPageHomeViewModel(myPageUseCase: myPageUseCase)
    viewModel.delegate = self

    let viewController = MyPageHomeViewController(viewModel: viewModel)

    self.viewControllable.setViewControllers([viewController])
  }

  public func editNicknameFlow(nickname: String) {

  }

  public func editphotoFlow() {

  }

  public func editPreferGenderBottomSheetFlow(prefetGender: SignUpInterface.Gender) {
    
  }

  public func editHeightBottomSheetFlow(height: Int) {

  }

  public func editUserContactsFlow() {
    let vm = UserContactSettingViewModel(useCase: self.myPageUseCase)
    vm.delegate = self
    let vc = UserContactSettingViewController(viewModel: vm)

    self.viewControllable.pushViewController(vc, animated: true)
  }

  public func settingFlow(_ user: User) {
    let vm = MySettingViewModel(useCase: self.myPageUseCase, locationUseCase: locationUseCase, user: user)
    let vc = MySettingsViewController(viewModel: vm)
    vm.delegate = self

    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension MyPageCoordinator: MyPageCoordinatingActionDelegate {
  public func invoke(_ action: MyPageCoordinatingAction) {
    switch action {
    case let .setting(user):
      settingFlow(user)
    case .editUserContacts:
      editUserContactsFlow()
    default: break
      
//    case .editNickname(let string):
//      <#code#>
//    case .editPhoto:
//      <#code#>
//    case .introduction(let string):
//      <#code#>
//    case .preferGender(let gender):
//      <#code#>
//    case .editHeight(let int):
//      <#code#>
//    case .editSmoke(let frequency):
//      <#code#>
//    case .editDrink(let frequency):
//      <#code#>
//    case .editReligion(let religion):
//      <#code#>
//    case .editInterest(let array):
//      <#code#>
//    case .editIdealType(let array):
//      <#code#>
    }
  }
}
