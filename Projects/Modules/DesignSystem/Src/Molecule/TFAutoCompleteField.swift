////
////  TFAutoCompleteField.swift
////  DSKit
////
////  Created by Kanghos on 8/1/24.
////
//
//import UIKit
//
//import Then
//import SnapKit
//
//protocol Decorator {
//  func decorate()
//}
//
//
//
//final class AutoCompleteDecorator {
//  private var target: any TFFieldProtocol
//
//  init(target: any TFFieldProtocol) {
//    self.target = target
//  }
//}
//
//struct TFAutoCompleteStyle {
//  let font: UIFont
//  let textColor: UIColor
//  let backgroundColor: UIColor
//}
//
//final class TFAutoCompleteField: UITextField {
//  let baseField = TFBaseField(placeholder: "")
//
//  var autoCompleteList: [String] = []
//  var autoCompleteStyle: TFAutoCompleteStyle = TFAutoCompleteStyle(
//    font: .thtH4R,
//    textColor: DSKitAsset.Color.neutral300.color,
//    backgroundColor: .clear
//  )
//
//  override var placeholder: String? {
//    didSet {
//      baseField.placeholder = new
//    }
//  }
//
//  private lazy var autoCompleteTableView = UITableView().then {
//    $0.backgroundColor = .clear
//    $0.separatorStyle = .none
//    $0.isHidden = true
//    $0.delegate = self
//    $0.dataSource = self
//  }
//}
//
//extension TFAutoCompleteField: UITableViewDelegate {
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let item = autoCompleteList[indexPath.item]
//    self.text = item
//  }
//}
//
//extension TFAutoCompleteField: UITableViewDataSource {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return autoCompleteList.count
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UITableViewCell.self)
//
//    var config = cell.defaultContentConfiguration()
//    config.text = autoCompleteList[indexPath.row]
//    config.textProperties.font = autoCompleteStyle.font
//    config.textProperties.color = autoCompleteStyle.textColor
//
//    cell.contentConfiguration = config
//    return cell
//  }
//}
