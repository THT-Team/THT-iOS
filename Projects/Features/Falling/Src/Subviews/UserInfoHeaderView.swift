//
//  UserInfoHeaderView.swift
//  Falling
//
//  Created by SeungMin on 3/12/24.
//

import UIKit
import DSKit

final class UserInfoHeaderView: UICollectionReusableView {
  let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.thtP2Sb
    label.textAlignment = .center
    label.textColor = DSKitAsset.Color.neutral50.color
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func makeUI() {
    addSubview(titleLabel)
        
    titleLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview()
    }
  }
}
