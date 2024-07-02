//
//  MyPageCoordinator+BottomSheet.swift
//  MyPage
//
//  Created by kangho lee on 7/23/24.
//

import Foundation

import DSKit

extension MyPageCoordinator: BottomSheetActionDelegate {
  public func sheetInvoke(_ action: BottomSheetViewAction) {
    switch action {
    case .onDismiss:
      self.viewControllable.dismiss()
    }
  }
}
