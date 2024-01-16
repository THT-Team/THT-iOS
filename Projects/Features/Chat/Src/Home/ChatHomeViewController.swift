//
//  ChatHomeViewController.swift
//  ChatInterface
//
//  Created by SeungMin on 1/16/24.
//

import UIKit

import Core
import DSKit

final class ChatHomeViewController: TFBaseViewController {
  let viewModel: ChatHomeViewModel
  
  init(viewModel: ChatHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func navigationSetting() {
    super.navigationSetting()
    
    navigationItem.title = "채팅"
    let notificationButtonItem = UIBarButtonItem(image: DSKitAsset.Image.Icons.bell.image, style: .plain, target: nil, action: nil)
    
    navigationItem.rightBarButtonItem = notificationButtonItem
  }
}
