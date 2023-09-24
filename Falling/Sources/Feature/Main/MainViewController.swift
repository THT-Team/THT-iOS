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
    output.timeText
      .drive(mainView.timerView.timerLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.timeColor
      .map { $0.color }
      .drive(mainView.timerView.timerLabel.rx.textColor)
      .disposed(by: disposeBag)
    
    output.timeColor
      .map { $0.color.cgColor }
      .drive(mainView.timerView.dotLayer.rx.strokeColor)
      .disposed(by: disposeBag)
    
    output.timeColor
      .map { $0.color.cgColor }
      .drive(mainView.timerView.dotLayer.rx.fillColor)
      .disposed(by: disposeBag)
    
    output.timeColor
      .map { $0.color.cgColor }
      .drive(mainView.timerView.strokeLayer.rx.strokeColor)
      .disposed(by: disposeBag)
    
    output.trackFillColor
      .map { $0.color.cgColor }
      .drive(mainView.timerView.trackLayer.rx.strokeColor)
      .disposed(by: disposeBag)
    
    output.dotPosition
      .map { CGPoint(x: self.mainView.timerView.bounds.midX + $0.x,
                     y: self.mainView.timerView.bounds.midY + $0.y) }
      .drive(mainView.timerView.dotLayer.rx.position)
      .disposed(by: disposeBag)
    
    output.isDotHidden
      .drive(mainView.timerView.dotLayer.rx.isHidden)
      .disposed(by: disposeBag)
    
    output.progress
      .map { round(CGFloat($0) * 100) / 100 }
      .drive(mainView.timerView.strokeLayer.rx.strokeEnd)
      .disposed(by: disposeBag)
    
    output.progress
      .map { CGFloat($0) }
      .drive(mainView.progressView.rx.progress)
      .disposed(by: disposeBag)
    
    output.timeColor
      .map { $0.color }
      .drive(mainView.progressView.rx.progressBarColor)
      .disposed(by: disposeBag)
  }
}
