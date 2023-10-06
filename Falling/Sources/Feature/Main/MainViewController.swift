//
//  MainViewController.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

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
    
    let output = viewModel.transform(input: MainViewModel.Input(trigger: initialTrigger))
    
    //    output.state
    //      .drive(mainView.rx.timeState)
    //      .disposed(by: disposeBag)
    
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<UserSection> { dataSource, collectionView, indexPath, item in
      
      let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                    cellType: MainCollectionViewCell.self)
      output.timeState
        .drive(cell.rx.timeState)
        .disposed(by: self.disposeBag)
      return cell
    }
    
    output.userList
      .drive(mainView.collectionView.rx.items(dataSource: dataSource))
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

struct MainViewControllerPreView: PreviewProvider {
  static var previews: some View {
    MainViewController(viewModel: MainViewModel(navigator: MainNavigator(controller: UINavigationController()))).toPreView()
  }
}
