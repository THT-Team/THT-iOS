//
//  ChatRoomView.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import Core
import DSKit

final class ChatRoomView: TFBaseView {

  lazy var backButton: UIBarButtonItem = .backButton
  lazy var exitButton: UIBarButtonItem = .exit
  lazy var reportButton: UIBarButtonItem = .report
  lazy var topicBar = TFTopicBannerView()
  private(set) lazy var chatInputView = ChatInputView()

  var bottomConstraint: NSLayoutConstraint?

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout.listLayoutAutomaticHeight(withEstimatedHeight: 50)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.refreshControl = self.refreshControl
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    return collectionView
  }()

  lazy var refreshControl = UIRefreshControl()

  override func makeUI() {
    self.backgroundColor = DSKitAsset.Color.neutral700.color
    self.addSubviews(topicBar, collectionView, chatInputView)

    topicBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(safeAreaLayoutGuide ).inset(10)
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(topicBar.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    chatInputView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(50).priority(.low)
    }
    bottomConstraint = chatInputView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
    bottomConstraint?.isActive = true
  }

  func topicBind(_ title: String, _ content: String) {
    self.topicBar.bind(title: title, content: content)
  }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatRoomViewPreview: PreviewProvider {

  static var previews: some View {
      UIViewPreview {
        let view = ChatRoomView()
        view.topicBind("반려동물", "asdfjsadlfkjasld")
        return view
      }
      .previewLayout(.sizeThatFits)
  }
}
#endif
