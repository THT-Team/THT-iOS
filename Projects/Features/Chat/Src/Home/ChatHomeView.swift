//
//  ChatListEmptyView.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/10.
//

import UIKit
import SwiftUI

import Core
import DSKit

final class ChatHomeView: TFBaseView {
  lazy var notiButton: UIBarButtonItem = .bling
  lazy var backgroundView = TFEmptyView(
    image: DSKitAsset.Bx.noMudy.image,
    title: "진행중인 대화가 없어요.",
    subTitle: "먼저 마음에 잘 맞는 무디들을 찾아볼까요?", 
    buttonTitle: "무디들 만나러 가기"
  )

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout.listLayout(withEstimatedHeight: 80)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundView = backgroundView
    collectionView.refreshControl = self.refreshControl
    collectionView.backgroundColor = DSKitAsset.Color.neutral700.color
    return collectionView
  }()

  lazy var refreshControl = UIRefreshControl()

  override func makeUI() {
    self.addSubview(collectionView)

    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}


#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct ChatListEmptyViewPreview: PreviewProvider {

  static var previews: some SwiftUI.View {
    UIViewPreview {
      return ChatHomeView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
