//
//  File.swift
//  SignUpInterface
//
//  Created by Kanghos on 2024/04/18.
//

import Foundation

public enum BottomSheetValueType {
  case date(date: Date)
  case text(text: String)
}

public enum BottomSheetViewAction {
  case onDismiss
}

public protocol BottomSheetActionDelegate: AnyObject {
  func sheetInvoke(_ action: BottomSheetViewAction)
}

public typealias BottomSheetHandler = ((BottomSheetValueType) -> Void)

public protocol BottomSheetListener: AnyObject {
  func sendData(item: BottomSheetValueType)
}

public protocol BottomSheetCoordinator {

}

public protocol PickerBottomSheetCoordinator: BottomSheetCoordinator {
  func pickerBottomSheetFlow(_ item: BottomSheetValueType, listener: BottomSheetListener)
}
