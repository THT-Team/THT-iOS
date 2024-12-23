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
  typealias CellType = MyPageDefaultTableViewCell

  private let mainView = MyPageDefaultTableView<CellType>()
  private let viewModel: MySettingViewModel

  fileprivate var dataSource: MySettingsDataSource!

  init(viewModel: MySettingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  override func loadView() {
    self.view = mainView
  }

  override func navigationSetting() {
    super.navigationSetting()

    self.navigationController?.setNavigationBarHidden(true, animated: false)

//    self.title = "설정 관리"
//    self.navigationItem.leftBarButtonItem = self.backButton
  }

  override func bindViewModel() {
    mainView.tableView.backgroundView = nil
    mainView.tableView.delegate = self
    configureDataSource()

    let itemSelected = mainView.tableView.rx.itemSelected
      .asDriver()
      .do(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)
      })

    let input = MySettingViewModel.Input(
      viewDidLoad: self.rx.viewDidAppear.asDriver().map { _ in },
      indexPath: itemSelected, 
      backBtnTap: self.mainView.backButton.rx.tap.asSignal()
    )

    let output = viewModel.transform(input: input)

    output.sections
      .drive(self.rx.sections)
      .disposed(by: disposeBag)

    output.toast
      .drive(with: self) { owner, message in
        owner.mainView.makeToast(message)
      }
      .disposed(by: disposeBag)
  }

  func configureDataSource() {

    dataSource = MySettingsDataSource(tableView: self.mainView.tableView) { (tableView, indexPath, item) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CellType.self)

      var content = cell.defaultContentConfiguration()

      switch SectionType(rawValue: indexPath.section) {
      case .account:
        cell.containerView.accessoryType = nil
        cell.containerView.isEditable = false
      case .location:
        cell.containerView.accessoryType = .pin
        cell.containerView.isEditable = true
//
//        let button = UIButton()
//        button.frame.size = .init(width: 160, height: 40)
//        let text = "ㅇㅇ시 ㅇㅇ구 ㅇㅇ동"
//        let range = NSRange(location: 0, length: text.count)
//        let mutableString = NSMutableAttributedString(string: text)
//        mutableString.addAttributes([
//          .foregroundColor: DSKitAsset.Color.primary500.color,
//          .font: UIFont.thtSubTitle2R
//        ], range: range)
//        button.titleLabel?.textAlignment = .right
//        button.setAttributedTitle(mutableString, for: .normal)
//        button.semanticContentAttribute = .forceRightToLeft
//        button.setImage(DSKitAsset.Image.Icons.locationSetting.image, for: .normal)
//        button.isUserInteractionEnabled = false
//        cell.accessoryView = button
//      default:
////        cell.accessoryType = .disclosureIndicator
////        cell.accessoryView = nil
      default:
        cell.containerView.accessoryType = .rightArrow
      }
      cell.containerView.text = item.title
      cell.containerView.contentText = item.content
      content.text = item.title
//      cell.contentConfiguration = content
      return cell
    }
    // initial data

    
  }
}

fileprivate typealias SectionType = MySetting.Section
fileprivate typealias ItemType = MySetting.MenuItem
fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>


// MARK: Move를 하면 DataSource를 subclass할 필요가 있지만, 아니라면 필요 없음 고로, 필요 없는 클래스!

fileprivate class MySettingsDataSource: UITableViewDiffableDataSource<SectionType, ItemType> {
}

extension MySettingsViewController : UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let text = dataSource.sectionIdentifier(for: section)?.header else {
      return nil
    }

    let header = UIView()

    let label = UILabel().then {
      $0.text = text
      $0.font = UIFont.thtP1R
      $0.textColor = DSKitAsset.Color.neutral300.color
    }

    header.addSubview(label)
    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-5)
    }

    return header
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard let text = dataSource.sectionIdentifier(for: section)?.footer else {
      return nil
    }

    let header = UIView()

    let label = UILabel().then {
      $0.text = text
      $0.font = UIFont.thtCaption1R
      $0.textColor = DSKitAsset.Color.neutral300.color
      $0.numberOfLines = 2
    }

    header.addSubview(label)

    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.top.equalToSuperview().offset(5)
      $0.bottom.equalToSuperview().offset(-5)
    }

    return header
  }
}

extension MySettingsViewController {
  fileprivate func bindSections(_ sections: [SectionModel<MySetting.MenuItem>]) {
    var snapshot = Snapshot()
    snapshot.appendSections(MySetting.Section.allCases)

    sections.forEach { section in
      snapshot.appendItems(section.items, toSection: section.type)
    }

    dataSource.apply(snapshot, animatingDifferences: false)
  }
}

extension Reactive where Base: MySettingsViewController {
  var sections: Binder<[SectionModel<MySetting.MenuItem>]> {
    return Binder(base) { owner, sections in
      owner.bindSections(sections)
    }
  }
}
