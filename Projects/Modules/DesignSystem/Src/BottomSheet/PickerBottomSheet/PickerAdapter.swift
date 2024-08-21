//
//  PickerAdapter.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//

import UIKit

import RxSwift
import RxCocoa

public final class PickerViewViewAdapter
: NSObject
, UIPickerViewDataSource
, UIPickerViewDelegate
, RxPickerViewDataSourceType
, SectionedViewDataSourceType {
  public typealias Element = [[Int]]

  private var items: Element = []

  public func model(at indexPath: IndexPath) throws -> Any {
    items[indexPath.section][indexPath.row]
  }

  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    items.count
  }

  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    items[component].count
  }
  
  public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 60
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard 
      let view = pickerView.view(forRow: row, forComponent: component),
      let label = view.subviews.first(where: { $0 is UILabel }) as? UILabel
    else { return }
    label.textColor = DSKitAsset.Color.primary500.color
  }

  public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    if let view = view {
      return view
    }
    let reuse = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
    label.text = "\(items[component][row])"
    label.textColor = DSKitAsset.Color.neutral400.color
    label.font = UIFont.thtH2B
    label.textAlignment = .center
    reuse.addSubview(label)
    return reuse
  }

  public func pickerView(_ pickerView: UIPickerView, observedEvent: Event<Element>) {
    Binder(self) { (adapter, items) in
      adapter.items = items
      pickerView.reloadAllComponents()
    }.on(observedEvent)
  }
}
