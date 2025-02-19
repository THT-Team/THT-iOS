//
//  EmailEditRootVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/27/24.
//

import Foundation
//
//  PhoneNumberEditInputVC.swift
//  MyPageInterface
//
//  Created by kangho lee on 7/27/24.
//


import UIKit

import Core
import DSKit

final class EmailEditRootVC: SettingBaseViewController {
  typealias ViewModel = EmailEditRootVM
  private let viewModel: ViewModel
  private var model: SingleSettingModel? {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  
  lazy var tableView = UITableView(frame: .zero, style: .insetGrouped).then {
    $0.showsVerticalScrollIndicator = false
    $0.register(cellType: UITableViewCell.self)
    $0.backgroundColor = DSKitAsset.Color.neutral700.color
  }
  
  lazy var updateBtn = WhiteStrokeMediumButton(title: "이메일 업데이트")

  override func makeUI() {
    self.view.backgroundColor = DSKitAsset.Color.neutral700.color
    self.view.addSubview(tableView)
    self.view.addSubview(updateBtn)

    tableView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    
    updateBtn.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(38.adjusted)
      $0.height.equalTo(54.adjustedH)
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-54.adjustedH)
    }
  }

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init()
  }

  override func bindViewModel() {
    tableView.dataSource = self
    tableView.delegate = self

    tableView.rx.itemSelected
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        self?.tableView.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: disposeBag)

    let input = ViewModel.Input(
      tap: updateBtn.rx.tap.asSignal()
    )

    let output = viewModel.transform(input: input)

    output.toast
      .emit(with: self) { owner, message in
        owner.view.makeToast(message)
      }
      .disposed(by: disposeBag)
    output.model
      .drive(with: self) { owner, model in
        owner.model = model
      }
      .disposed(by: disposeBag)
  }

  override func navigationSetting() {
    super.navigationSetting()
    self.title = "이메일"
  }
}

// TODO: 공통 된 거 처리할 수 있는 Adapter 만들기
extension EmailEditRootVC: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let header = UIView()

    let label = UILabel().then {
      $0.text = self.model?.header
      $0.font = UIFont.thtP1R
      $0.textColor = DSKitAsset.Color.neutral50.color
    }

    header.addSubview(label)
    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(20)
      $0.bottom.equalToSuperview().offset(-5)
    }

    return header
  }
}

extension EmailEditRootVC: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
    var content = cell.defaultContentConfiguration()
    cell.accessoryView = nil

    content.text = self.model?.content
    content.textProperties.font = .thtSubTitle1R
    content.textProperties.color = DSKitAsset.Color.neutral50.color

    cell.accessoryView = UIImageView(image: DSKitAsset.Image.Icons.shield.image)
    cell.contentConfiguration = content
    return cell
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

    return model?.footer
  }
}
