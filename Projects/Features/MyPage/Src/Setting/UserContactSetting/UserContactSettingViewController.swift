//
//  UserContactSettingViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/10/24.
//

import UIKit

import Core
import DSKit

final class UserContactSettingViewController: TFBaseViewController {
  private let mainView = UserContactSettingView()
  private let viewModel: UserContactSettingViewModel

  static let reuseIdentifier = "cell"
  private let updateContactTap = PublishRelay<Void>()

  init(viewModel: UserContactSettingViewModel) {
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

    mainView.tableView.rx.itemSelected
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: disposeBag)
    
    let tap = updateContactTap.asDriverOnErrorJustEmpty()

    let input = UserContactSettingViewModel.Input(tap: tap)

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
    self.title = "저장된 연락처 차단하기"
  }
}

extension UserContactSettingViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Self.reuseIdentifier, for: indexPath)
    var content = cell.defaultContentConfiguration()
    cell.accessoryView = nil

    content.text = "연락처에 저장된 지인 만나기 않기"
    content.textProperties.font = .thtSubTitle1R

    content.secondaryText = "0개의 연락처 차단 완료"
    content.secondaryTextProperties.color = DSKitAsset.Color.event.color
    content.secondaryTextProperties.font = .thtP2R

    let button = UIButton(primaryAction: UIAction(handler: { [weak self] _ in
      self?.updateContactTap.accept(Void())
    }))
    button.backgroundColor = DSKitAsset.Color.primary500.color
    button.layer.cornerRadius = 15
    button.layer.masksToBounds = true
    button.setTitleColor(DSKitAsset.Color.neutral500.color, for: .normal)
    button.frame.size = .init(width: 80, height: 30)
    let text = "업데이트"
    let range = NSRange(location: 0, length: text.count)
    let mutableString = NSMutableAttributedString(string: text)
    mutableString.addAttributes([
      .foregroundColor: DSKitAsset.Color.neutral500.color,
      .font: UIFont.thtP2Sb
    ], range: range)
    button.setAttributedTitle(mutableString, for: .normal)
    cell.accessoryView = button
    cell.contentConfiguration = content
    return cell
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let text = "연락처 차단"
    let range = NSRange(location: 0, length: text.count)
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttributes([
      .foregroundColor: DSKitAsset.Color.neutral50.color,
      .font: UIFont.thtH1B
    ], range: range)
    return attributedString.string
  }

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

    return "모든 정보는 암호화되어 안전하게 보호되며, 어떠한 경우에도 제3자에게\n공개되지 않습니다."
  }
}
