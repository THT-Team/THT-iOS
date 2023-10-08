//
//  MainViewController.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

final class MainViewController: TFBaseViewController {
  
  private let viewModel: MainViewModel
  private lazy var mainView = MainView()
  private var dataSource: UICollectionViewDiffableDataSource<MainProfileSection, UserDomain>!
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setupDelegate()
  }
  
  override func loadView() {
    self.view = mainView
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func navigationSetting() {
    super.navigationSetting()
    
    navigationItem.title = "가치관"
    let mindImageView = UIImageView(image: FallingAsset.Image.mind.image)
    let mindImageItem = UIBarButtonItem(customView: mindImageView)
    
    let notificationButtonItem = UIBarButtonItem(image: FallingAsset.Image.bell.image, style: .plain, target: nil, action: nil)
    
    navigationItem.leftBarButtonItem = mindImageItem
    navigationItem.rightBarButtonItem = notificationButtonItem
  }
  
  override func bindViewModel() {
    let initialTrigger = self.rx.viewWillAppear.map { _ in }.asDriverOnErrorJustEmpty()
    
    let timerOverTrigger = self.rx.timeOverTrigger.map { _ in
    }.asDriverOnErrorJustEmpty()
    
    let output = viewModel.transform(input: MainViewModel.Input(trigger: initialTrigger, timeOverTrigger: timerOverTrigger))
    
    var count = 0
    output.userList
      .drive { userSection in
        count = userSection.count
      }.disposed(by: disposeBag)

    // DiffableDataSource

    let profileCellRegistration = UICollectionView.CellRegistration<MainCollectionViewCell, UserDomain> { [weak self] cell, indexPath, item in
      cell.setup(item: item)
      cell.delegate = self
      output.currentPage
        .filter { $0 == indexPath.item }
        .drive(onNext: {_ in
        cell.bindViewModel()
      })
      .disposed(by: cell.disposeBag)
    }

    dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
    output.userList
      .drive(onNext: { [weak self] list in
        var snapshot = NSDiffableDataSourceSnapshot<MainProfileSection, UserDomain>()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list)
        self?.dataSource.apply(snapshot, animatingDifferences: true)
      }).disposed(by: disposeBag)
    
    output.currentPage
      .do(onNext: { index in
        let index = index >= count ? count - 1 : index
        let indexPath = IndexPath(row: index, section: 0)
        self.mainView.collectionView.scrollToItem(at: indexPath,
                                                  at: .top,
                                                  animated: true)
      }).drive()
      .disposed(by: self.disposeBag)
  }
  
  private func setupDelegate() {
    mainView.collectionView.delegate = self
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width - 32,
                  height: (view.frame.width - 32) * 1.64)
  }
}

extension MainViewController: TimeOverDelegate {
  @objc func scrollToNext() { }
}

extension Reactive where Base: MainViewController {
  var timeOverTrigger: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.scrollToNext)).map { _ in }
    return ControlEvent(events: source)
  }
}

#if DEBUG
import SwiftUI

struct MainViewControllerPreView: PreviewProvider {
  static var previews: some View {
    let navigator = MainNavigator(controller: UINavigationController())

    let viewModel = MainViewModel(navigator: navigator)

    return MainViewController(viewModel: viewModel)
      .toPreView()
  }
}
#endif
