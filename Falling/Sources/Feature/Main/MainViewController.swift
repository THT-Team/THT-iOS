//
//  MainViewController.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit
import RxCocoa

final class MainViewController: TFBaseViewController {
  
  private let viewModel: MainViewModel
  private lazy var mainView = MainView()
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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
  override func loadView() {
    self.view = mainView
  }
  
  override func bindViewModel() {
    let output = viewModel.transform(input: MainViewModel.Input())

    output.state
      .drive(mainView.rx.timeState)
      .disposed(by: disposeBag)
  }
}
