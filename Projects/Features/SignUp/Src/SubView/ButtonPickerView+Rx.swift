//
//  ButtonPickerView+Rx.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: ButtonPickerView {
  var selectedOption: ControlProperty<ButtonPickerView.ButtonOption?> {
    return base.rx.controlProperty(
      editingEvents: .valueChanged,
      getter: { base in
        base.selectedOption
      },
      setter: { base, value in
        if base.selectedOption != value {
          base.selectedOption = value
        }
      }
    )
  }
}

extension Reactive where Base: TFButtonPickerView {
  var selectedOption: ControlProperty<TFButtonPickerView.Option?> {
    return base.rx.controlProperty(
      editingEvents: .valueChanged,
      getter: { base in
        base.selectedOption
      },
      setter: { base, value in
        if base.selectedOption != value {
          base.selectedOption = value
        }
      }
    )
  }
}
