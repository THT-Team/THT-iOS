//
//  SettingViewController.swift
//  MyPageInterface
//
//  Created by Kanghos on 6/9/24.
//

import UIKit

import Core
import DSKit

final class MySettingsViewController: TFBaseViewController {
  private let mainView = MySettingView()
  private let viewModel: MySettingViewModel

  static let reuseIdentifier = "cell"

  fileprivate var dataSource: MySettingsDataSource!

  private let backButton: UIBarButtonItem = .backButton

  init(viewModel: MySettingViewModel) {
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
    configureDataSource()
    mainView.tableView.separatorStyle = .singleLine

    let itemSelected = mainView.tableView.rx.itemSelected
      .asDriver()
      .do(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })

    let input = MySettingViewModel.Input(
      viewDidLoad: self.rx.viewDidAppear.asDriver().map { _ in },
      indexPath: itemSelected, 
      backBtnTap: self.backButton.rx.tap.asSignal()
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

    self.title = "설정 관리"
    self.navigationItem.leftBarButtonItem = self.backButton
  }

  func configureDataSource() {

    // data source

    dataSource = MySettingsDataSource(tableView: self.mainView.tableView) { (tableView, indexPath, item) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: MySettingsViewController.reuseIdentifier, for: indexPath)
      cell.accessoryView = nil
      var content = cell.defaultContentConfiguration()

      switch SectionType(rawValue: indexPath.section) {
      case .account:
        let label = UIButton(frame: .init(origin: .zero, size: .init(width: 100, height: 40)))
        label.setTitle("Google", for: .normal)
        label.titleLabel?.textAlignment = .right
        label.setTitleColor(DSKitAsset.Color.neutral300.color, for: .normal)

        cell.accessoryView = label
      case .location:
        let button = UIButton()
        button.frame.size = .init(width: 160, height: 40)
        let text = "ㅇㅇ시 ㅇㅇ구 ㅇㅇ동"
        let range = NSRange(location: 0, length: text.count)
        let mutableString = NSMutableAttributedString(string: text)
        mutableString.addAttributes([
          .foregroundColor: DSKitAsset.Color.primary500.color,
          .font: UIFont.thtSubTitle2R
        ], range: range)
        button.titleLabel?.textAlignment = .right
        button.setAttributedTitle(mutableString, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(DSKitAsset.Image.Icons.locationSetting.image, for: .normal)
        button.isUserInteractionEnabled = false
        cell.accessoryView = button
      default:
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = nil
      }
      content.text = item.title
      cell.contentConfiguration = content
      return cell
    }

    // initial data

    let snapshot = initialSnapshot()
    dataSource.apply(snapshot, animatingDifferences: false)
  }

   fileprivate func initialSnapshot() -> Snapshot {
    var snapshot = Snapshot()

    snapshot.appendSections([.account, .activity, .location, .notification, .support, .law, .accoutSetting])

    snapshot.appendItems([
      ItemType(title: "연동된 SNS"),
    ], toSection: .account)

    snapshot.appendItems([
      ItemType(title: "저장된 연락처 차단하기"),
    ], toSection: .activity)

    snapshot.appendItems([
      ItemType(title: "위치 설정"),
    ], toSection: .location)

    snapshot.appendItems([
      ItemType(title: "알림 설정"),
    ], toSection: .notification)

    snapshot.appendItems([
      ItemType(title: "자주 묻는 질문"),
      ItemType(title: "문의 및 피드백 보내기"),
    ], toSection: .support)

    snapshot.appendItems([
      ItemType(title: "서비스 이용약관"),
      ItemType(title: "개인정보 처리방침"),
      ItemType(title: "위치정보 이용약관"),
      ItemType(title: "라이센스"),
      ItemType(title: "사업자 정보"),
    ], toSection: .law)

    snapshot.appendItems([
      ItemType(title: "계정 설정"),
    ], toSection: .accoutSetting)

    return snapshot
  }
}

fileprivate typealias SectionType = MySetting.Section
fileprivate typealias ItemType = MySetting.Item
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>

fileprivate class MySettingsDataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let sectionKind = SectionType(rawValue: section)
    return sectionKind?.header
  }
  override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
    let sectionKind = SectionType(rawValue: section)
    return sectionKind?.footer
  }
}
