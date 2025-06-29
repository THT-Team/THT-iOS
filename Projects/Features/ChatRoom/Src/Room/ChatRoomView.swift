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
  private(set) var dataSource: DataSource!

  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout.bubbleLayoutWithHeader()
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
          view.setupDataSource()
          view.applySnapshot(items: [])
        return view
      }
      .previewLayout(.sizeThatFits)
  }
}
#endif

extension ChatRoomView {
  typealias Model = ChatViewSectionItem
  typealias DataSource = UICollectionViewDiffableDataSource<Date, Model>
  typealias Snapshot = NSDiffableDataSourceSnapshot<Date, Model>
  typealias OutgoingCellRegistration = UICollectionView.CellRegistration<OutgoingBubbleCell, BubbleReactor>
  typealias IncomingCellRegistration = UICollectionView.CellRegistration<IncomingBubbleCell, BubbleReactor>
  typealias DateReusableViewRegistration = UICollectionView.SupplementaryRegistration<DateReusableView>

  func setupDataSource() {
    let bubbleRegistration = OutgoingCellRegistration { cell, _, item in
      cell.bind(reactor: item)
    }

    let myBubbleRegistration = IncomingCellRegistration { cell, _, item in
      cell.bind(reactor: item)
    }

    let dateSupplementRegistration = DateReusableViewRegistration(elementKind: UICollectionView.elementKindSectionHeader) { [weak self] supplementaryView, elementKind, indexPath in
      let date = self?.dataSource.sectionIdentifier(for: indexPath.section)
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .none
      
      supplementaryView.bind(formatter.string(from: date ?? .now))
    }

    self.dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
      switch item.type {
      case let .incoming:
        collectionView.dequeueConfiguredReusableCell(using: myBubbleRegistration, for: indexPath, item: item.reactor)
      case let .outgoing:
        collectionView.dequeueConfiguredReusableCell(using: bubbleRegistration, for: indexPath, item: item.reactor)
      }
    }

    self.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
      collectionView.dequeueConfiguredReusableSupplementary(using: dateSupplementRegistration, for: indexPath)
    }

    applySnapshot(items: [])
  }

  func applySnapshot(items: [ChatViewSection]) {
    var snapshot = Snapshot()
    
    snapshot.appendSections(items.map(\.date))
    
    items.forEach { section in
      snapshot.appendItems(section.items, toSection: section.date)
    }

    dataSource.apply(snapshot)
  }
  
  func scrollToBottom() {
    collectionView.scrollToBottom()
  }
}

extension UICollectionView {
    func scrollToBottom(animated: Bool = true) {
        DispatchQueue.main.async {
            let sections = self.numberOfSections
            guard sections > 0 else { return }
            
            let lastSection = sections - 1
            let itemCount = self.numberOfItems(inSection: lastSection)
            guard itemCount > 0 else { return }
            
            let indexPath = IndexPath(item: itemCount - 1, section: lastSection)
            self.scrollToItem(at: indexPath, at: .bottom, animated: animated)
        }
    }
}
