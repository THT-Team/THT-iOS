//
//  PolicyAgreementViewController.swift
//  Falling
//
//  Created by Hoo's MacBookPro on 2023/10/02.
//

import UIKit

import DSKit

final class PolicyAgreementViewController: TFBaseViewController {
  private let viewModel: PolicyAgreementViewModel

  private lazy var customView = PolicyAgreementView()

  init(viewModel: PolicyAgreementViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func makeUI() {
    view.addSubview(customView)

    customView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
  }

  override func bindViewModel() {
    let cellAction = PublishRelay<(IndexPath, PolicyAgreementViewModel.CellAction)>()

    customView.tableView.rx.itemSelected.asDriver()
      .drive(onNext: { indexPath in
        cellAction.accept((indexPath, .Agree))
      }).disposed(by: disposeBag)

    let input = PolicyAgreementViewModel.Input(
      viewWillAppear: rx.viewWillAppear.asDriver().map { _ in },
      agreeAllBtn: customView.selectAllBtn.rx.tap.asDriver(),
      cellTap: cellAction.asDriverOnErrorJustEmpty(),
      nextBtn: customView.nextBtn.rx.tap.asDriver()
    )

    let output = viewModel.transform(input: input)

    output.cellViewModels
      .drive(customView.tableView.rx.items(cellType: ServiceAgreementRowView.self)) { index, viewModel, cell in
        cell.bind(viewModel)
        cell.agreeBtnOnCliek = {
          cellAction.accept((IndexPath(row: index, section: 0), .Agree))
        }
        cell.goWebviewBtnOnClick = {
          cellAction.accept((IndexPath(row: index, section: 0), .WebView))
        }
      }
      .disposed(by: disposeBag)

    output.agreeAllBtnStatus
      .drive(customView.selectAllBtn.rx.buttonStatus)
      .disposed(by: disposeBag)

    output.nextBtnStatus
      .drive(customView.nextBtn.rx.buttonStatus)
      .disposed(by: disposeBag)
  }
}
