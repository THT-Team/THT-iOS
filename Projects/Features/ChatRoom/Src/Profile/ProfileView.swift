//
//  ProfileView.swift
//  ChatRoom
//
//  Created by Kanghos on 1/28/25.
//

import UIKit
import Core
import DSKit

public final class ProfileView: TFBaseView {

  private(set) lazy var topicBarView = TFTopicBarView()
  private(set) lazy var visualEffectView: UIVisualEffectView = {
    let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
    visualView.isHidden = true
    return visualView
  }()

  private(set) lazy var profileCollectionView: UICollectionView = .createProfileCollectionView()

  public override func makeUI() {
    self.backgroundColor = .clear
    [topicBarView, profileCollectionView, visualEffectView].forEach {
      self.addSubview($0)
    }
    visualEffectView.isHidden = true
    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    topicBarView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.top.equalToSuperview().offset(100)
    }
    profileCollectionView.snp.makeConstraints {
      $0.top.equalTo(topicBarView.snp.bottom).offset(10)
      $0.bottom.equalToSuperview().inset(100)
      $0.leading.trailing.equalTo(topicBarView)
    }
  }
}


