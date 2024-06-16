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
  private let cellTap = PublishRelay<IndexPath>()
  private let footerDescription = BehaviorRelay<String>(value: "")

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
    mainView.tableView.delegate = self
    mainView.tableView.backgroundView = nil

    mainView.tableView.rx.itemSelected.asSignal()
      .do(onNext: { [weak self] indexPath in
        self?.mainView.tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = self?.mainView.tableView.cellForRow(at: indexPath) as? CellType else {
          return
        }
        guard let alarmSwitch = cell.containerView.accessoryView as? UISwitch else {
          return
        }
        alarmSwitch.setOn(!alarmSwitch.isOn, animated: true)
        return
      })
      .emit(to: cellTap)
      .disposed(by: disposeBag)

    let input = VMType.Input(
      tap: cellTap.asSignal()
      )

    let output = viewModel.transform(input: input)

    output.toast
      .emit(with: self) { owner, message in
        owner.mainView.makeToast(message)
      }
      .disposed(by: disposeBag)

    output.alarmSection
      .drive(with: self) { owner, sections in
        owner.updateSections(sections)
      }.disposed(by: disposeBag)

    output.marketingDescription
      .drive(footerDescription)
      .disposed(by: disposeBag)

//    output.updateMarketingSection
//      .drive(with: self) { owner, section in
//        owner.sections[0] = section
//        owner.mainView.tableView.beginUpdates()
//        owner.mainView.tableView.reloadSections(IndexSet(integer: 0), with: .none)
//        owner.mainView.tableView.endUpdates()
//      }
//      .disposed(by: disposeBag)
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

extension AlarmSettingViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let text = sections[section].title else {
      return nil
    }

    let header = UIView()

    let label = UILabel().then {
      $0.text = text
      $0.font = UIFont.thtP1R
      $0.textColor = DSKitAsset.Color.neutral50.color
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
    guard let text = sections[section].description else {
      return nil
    }

    let header = UIView()

    let label = UILabel().then {
      $0.text = text
      $0.font = UIFont.thtCaption2R
      $0.textColor = DSKitAsset.Color.neutral300.color
      $0.numberOfLines = 2
    }

    header.addSubview(label)

    label.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(16)
      $0.centerY.equalToSuperview()
    }

    if section == 0 {
      footerDescription
        .skip(1)
        .bind(to: label.rx.text)
        .disposed(by: disposeBag)
    }

    return header
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

    let alarmSwitch = UISwitch(frame: .zero).then {
      $0.isOn = model.isOn
      $0.tag = indexPath.item
      $0.onTintColor = DSKitAsset.Color.primary500.color
      $0.frame.size = UIView.layoutFittingCompressedSize
    }

    alarmSwitch.addAction(UIAction { [weak self] action in
      self?.cellTap.accept(indexPath)
    }, for: .valueChanged)

    cell.containerView.accessoryView = alarmSwitch
    cell.containerView.text = model.title
    cell.containerView.secondaryText = model.secondaryTitle

    return cell
  }
}
