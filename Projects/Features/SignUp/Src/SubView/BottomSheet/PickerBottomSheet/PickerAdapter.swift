//
//  PickerAdapter.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import DSKit
import RxSwift
import RxCocoa

final class PickerViewViewAdapter
: NSObject
, UIPickerViewDataSource
, UIPickerViewDelegate
, RxPickerViewDataSourceType
, SectionedViewDataSourceType {
  typealias Element = [[Int]]

  private var items: Element = []

  func model(at indexPath: IndexPath) throws -> Any {
    items[indexPath.section][indexPath.row]
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    items.count
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    items[component].count
  }

  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let label: UILabel = (view as? UILabel) ?? UILabel()
    label.text = "\(items[component][row])"
    label.textColor = DSKitAsset.Color.primary500.color
    label.font = UIFont.thtH2B
    label.textAlignment = .center
    return label
  }

  func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
    Binder(self) { (adapter, items) in
      adapter.items = items
      pickerView.reloadAllComponents()
    }.on(observedEvent)
  }
}
