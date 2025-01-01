//
//  InquiryCoordinator.swift
//  AuthInterface
//
//  Created by Kanghos on 7/21/24.
//

import Foundation
import AuthInterface

import Core

public final class InquiryCoordinator: BaseCoordinator, InquiryCoordinating {
  public var finishFlow: (() -> Void)?

  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let vm = InquiryViewModel()
    vm.onBackButtonTap = { [weak self] in
      self?.viewControllable.popViewController(animated: true)
      self?.finishFlow?()
    }
    let vc = InquiryViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
}
