//
//  ChatRoomView.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import DSKit

final class ChatRoomView: TFBaseView {

  lazy var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
  lazy var backButton: UIBarButtonItem = .backButton
  lazy var exitButton: UIBarButtonItem = .exit
  lazy var reportButton: UIBarButtonItem = .report
  lazy var topicBar = TFTopicBannerView()
  private(set) lazy var chatInputView = ChatInputView()

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout.listLayoutAutomaticHeight(withEstimatedHeight: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.refreshControl = self.refreshControl
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    collectionView.keyboardDismissMode = .interactive
    return collectionView
  }()

  lazy var refreshControl = UIRefreshControl()

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    self.addSubviews(topicBar, collectionView, chatInputView, visualEffectView)

    topicBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide ).inset(10)
    }

    visualEffectView.isHidden = true
    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(topicBar.snp.bottom)
      $0.leading.trailing.equalToSuperview()
    }
    chatInputView.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50).priority(.low)
    }
    chatInputView.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor).isActive = true
  }

  func topicBind(_ title: String, _ content: String) {
    self.topicBar.bind(title: title, content: content)
  }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatRoomViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
      UIViewPreview {
        let view = ChatRoomView()
        view.topicBind("반려동물", "asdfjsadlfkjasld")
        return view
      }
      .previewLayout(.sizeThatFits)
  }
}
#endif
