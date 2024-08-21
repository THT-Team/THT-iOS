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

  public weak var delegate: InquiryCoordinatingDelegate?

  public override func start() {
    homeFlow()
  }

  public func homeFlow() {
    let vm = InquiryViewModel()
    vm.delegate = self
    let vc = InquiryViewController(viewModel: vm)
    self.viewControllable.pushViewController(vc, animated: true)
  }
}

extension InquiryCoordinator: InquiryCoordinatingActionDelegate {
  public func invoke(_ action: InquiryCoordinatingAction) {
    switch action {
    case .finish:
      self.viewControllable.popViewController(animated: true)
      self.delegate?.detachInquiry(self)
    }
  }
}

