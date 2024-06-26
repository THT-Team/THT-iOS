//
//  AccountSettingViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/13/24.
//

import UIKit

import Core
import DSKit

final class AccountSettingViewController: TFBaseViewController {
  typealias VMType = AccountSettingViewModel
  typealias CellType = MyPageDefaultTableViewCell
  private let mainView = AccountSettingView<CellType>()
  private let viewModel: VMType

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

    let tap = mainView.tableView.rx.itemSelected
      .asDriver()
      .do(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })
      .mapToVoid()

    let input = VMType.Input(
      tap: tap,
      deactivateTap: mainView.deactivateBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.toast
      .debug("vc toast")
      .drive(with: self) { owner, message in
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)

        owner.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          owner.dismiss(animated: true)
        }
      }
      .disposed(by: disposeBag)
  }

  override func navigationSetting() {
    super.navigationSetting()
    self.title = "계정 관리"
  }
}

extension AccountSettingViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CellType.self)

    cell.containerView.text = "로그아웃"
    cell.containerView.accessoryType = .rightArrow
    var content = cell.defaultContentConfiguration()

    content.text = "로그아웃"
    content.textProperties.font = .thtSubTitle1R

//    cell.contentConfiguration = content
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "계정 관리"
  }
}
