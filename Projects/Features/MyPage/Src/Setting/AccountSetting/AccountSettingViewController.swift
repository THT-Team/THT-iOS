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
    self.navigationController?.setNavigationBarHidden(false, animated: true)
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

    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "계정 관리"
  }
}
