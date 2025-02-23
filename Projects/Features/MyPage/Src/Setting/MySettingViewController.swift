//
//  SettingViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

import Core
import DSKit

import MyPageInterface

final class MySettingsViewController: TFBaseViewController {
  private let mainView = MySettingView()
  private let viewModel: MySettingViewModel

  init(viewModel: MySettingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  override func loadView() {
    self.view = mainView
  }

  override func navigationSetting() {
    super.navigationSetting()

    setBackButton()

    let label = UILabel().then {
      $0.text = "설정 관리"
      $0.textColor = DSKitAsset.Color.neutral50.color
      $0.font = .thtH4Sb
    }
    self.view.addSubview(label)

    label.snp.makeConstraints {
      $0.centerY.equalTo(backButton)
      $0.leading.equalTo(backButton.snp.trailing).offset(16.adjusted)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    super.viewWillAppear(animated)
  }

  override func bindViewModel() {

    let itemSelected = mainView.tableView.rx.itemSelected
      .asDriver()
      .do(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })

    let input = MySettingViewModel.Input(
      indexPath: itemSelected, 
      backBtnTap: self.backButton.rx.tap.asSignal()
    )

    let output = viewModel.transform(input: input)

    output.sections
      .drive(with: self, onNext: { owner, sections in
        owner.mainView.sections = sections
      })
      .disposed(by: disposeBag)

    output.toast
      .asObservable()
      .bind(to: TFToast.shared.rx.makeToast)
      .disposed(by: disposeBag)
  }
}
