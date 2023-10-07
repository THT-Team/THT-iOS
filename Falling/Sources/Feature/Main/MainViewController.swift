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
import SwiftUI

final class MainViewController: TFBaseViewController {
  
  private let viewModel: MainViewModel
  private lazy var mainView = MainView()
  
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
        count = userSection[0].items.count
      }.disposed(by: disposeBag)
    
    
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<UserSection> { dataSource, collectionView, indexPath, item in
      
      let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                    cellType: MainCollectionViewCell.self)
      cell.setup(item: item)
      output.currentPage
        .do { index in
          if index == indexPath.row {
            cell.bindViewModel()
          }
        }.drive()
        .disposed(by: self.disposeBag)
      cell.delegate = self
      return cell
    }
    
    output.userList
      .drive(mainView.collectionView.rx.items(dataSource: dataSource))
      .disposed(by: self.disposeBag)
    
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

struct MainViewControllerPreView: PreviewProvider {
  static var previews: some View {
    MainViewController(viewModel: MainViewModel(navigator: MainNavigator(controller: UINavigationController()))).toPreView()
  }
}
