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
  private let mainView = MainView()
  
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
  
  override func makeUI() {
    self.view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    let output = viewModel.transform(input: MainViewModel.Input())
    output.timerText
      .drive(mainView.timerLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.progress
      .drive(mainView.progressView.rx.progress)
      .disposed(by: disposeBag)
    
    output.timerColor
      .map { $0.color }
      .drive(mainView.timerLabel.rx.textColor)
      .disposed(by: disposeBag)
    
    output.timerColor
      .map { $0.color }
      .drive(mainView.progressView.rx.progressTintColor)
      .disposed(by: disposeBag)
  }
}
