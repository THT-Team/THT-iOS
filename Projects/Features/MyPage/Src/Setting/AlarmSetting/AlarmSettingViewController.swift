//
//  AlarmSettingViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/14/24.
//

import UIKit

import Core
import DSKit

final class AlarmSettingViewController: TFBaseViewController {
  typealias CellType = MyPageDefaultTableViewCell
  typealias VMType = AlarmSettingViewModel

  private let mainView = MyPageDefaultTableView<CellType>()
  private let viewModel: VMType
  private var sections = [AlarmSection]()

  static let reuseIdentifier = "cell"

  init(viewModel: VMType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }

  override func bindViewModel() {
    mainView.tableView.dataSource = self

    let tap = mainView.tableView.rx.itemSelected.asSignal()
      .do(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })

    let input = VMType.Input(
      viewDidLoad: self.rx.viewDidAppear.asSignal().map { _ in },
      tap: tap
      )

    let output = viewModel.transform(input: input)

    output.toast
      .debug("vc toast")
      .emit(with: self) { owner, message in
        owner.mainView.makeToast(message)
      }
      .disposed(by: disposeBag)

    output.alarmSection
      .drive(with: self) { owner, sections in
        owner.updateSections(sections)
      }.disposed(by: disposeBag)
  }

  override func navigationSetting() {
    super.navigationSetting()
    self.title = "알람 설정"
  }
}

extension AlarmSettingViewController {
  func updateSections(_ sections: [AlarmSection]) {
    self.sections = sections
    mainView.tableView.reloadData()
  }
}

extension AlarmSettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    sections.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sections[section].items.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CellType.self)
    let model = sections[indexPath.section].items[indexPath.item]

    let alarmSwitch = UISwitch().then {
      $0.isOn = model.isOn
      $0.tag = indexPath.item
      $0.onTintColor = DSKitAsset.Color.primary500.color
    }

    cell.containerView.accessoryView = alarmSwitch
    cell.containerView.text = model.title
    cell.containerView.secondaryText = model.secondaryTitle

    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    sections[section].description
  }
}
