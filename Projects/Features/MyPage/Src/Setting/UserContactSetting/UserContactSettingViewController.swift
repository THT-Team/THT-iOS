//
//  UserContactSettingViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/10/24.
//

import UIKit

import Core
import DSKit

final class UserContactSettingViewController: SettingBaseViewController {
  private let mainView = UserContactSettingView()
  private let viewModel: UserContactSettingViewModel

  static let reuseIdentifier = "cell"
  private let updateContactTap = PublishRelay<Void>()

  var fetchedContactNumber: Int = 0 {
    didSet {
      DispatchQueue.main.async {
        self.mainView.tableView.reloadData()
      }
    }
  }

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
    mainView.tableView.delegate = self

    mainView.tableView.rx.itemSelected
      .asDriver()
      .drive(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })
      .disposed(by: disposeBag)
    
    let tap = updateContactTap.asDriverOnErrorJustEmpty()

    let input = UserContactSettingViewModel.Input(
      viewDidAppear: self.rx.viewDidAppear.asDriver().mapToVoid(),
      tap: tap
    )

    let output = viewModel.transform(input: input)

    output.toast
      .asObservable()
      .bind(to: TFToast.shared.rx.makeToast)
      .disposed(by: disposeBag)

    output.fetchedContactCount
      .drive(with: self) {
        $0.fetchedContactNumber = $1
      }.disposed(by: disposeBag)
  }

  override func navigationSetting() {
    super.navigationSetting()
    self.title = "저장된 연락처 차단하기"
  }
}

// TODO: 공통 된 거 처리할 수 있는 Adapter 만들기
extension UserContactSettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let header = UIView()

    let label = UILabel().then {
      $0.text = "연락처 차단"
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

    content.secondaryText = "\(self.fetchedContactNumber)개의 연락처 차단 완료"
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

  func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {

    return "모든 정보는 암호화되어 안전하게 보호되며, 어떠한 경우에도 제3자에게 공개되지 않습니다."
  }
}
