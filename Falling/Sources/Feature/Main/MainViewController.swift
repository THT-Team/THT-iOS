//
//  MainViewController.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

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
  
  override func makeUI() {
    self.navigationController?.navigationBar.isHidden = true
    
    self.view.addSubview(mainView)
    mainView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.trailing.equalToSuperview()
    }
  }
  
  override func bindViewModel() {
    
  }
}
