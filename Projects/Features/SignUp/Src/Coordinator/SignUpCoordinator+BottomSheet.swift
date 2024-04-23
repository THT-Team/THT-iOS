//
//  SignUpCoordinator+BottomSheet.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/21.
//

import Foundation

import Core
import SignUpInterface

extension SignUpCoordinator: PickerBottomSheetCoordinator {
  public func pickerBottomSheetFlow(_ item: BottomSheetValueType, listener: BottomSheetListener) {
    let vm = PickerBottomSheetViewModel(initialValue: item)
    vm.listener = listener
    vm.delegate = self
    let vc = PickerBottomSheet(viewModel: vm)

    self.viewControllable.presentBottomSheet(vc, animated: true)
  }

  public func singlePickerBottomSheetFlow(_ item: BottomSheetValueType, listener: BottomSheetListener) {
    let vm = SinglePickerBottomSheetViewModel(initialValue: item)
    vm.listener = listener
    vm.delegate = self
    let vc = SinglePickerBottomSheet(viewModel: vm)
    self.viewControllable.presentBottomSheet(vc, animated: true)
  }
}
