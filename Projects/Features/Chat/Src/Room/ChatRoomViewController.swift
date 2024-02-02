//
//  ChatRoomViewController.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/14.
//

import UIKit

import Core
import DSKit
import ChatInterface

final class ChatRoomViewController: TFBaseViewController {
  private lazy var mainView = ChatRoomView()
  private let viewModel: ChatRoomViewModel
  private var dataSource: DataSource!

  init(viewModel: ChatRoomViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }

  override func navigationSetting() {
    super.navigationSetting()

    navigationItem.leftBarButtonItem = self.mainView.backButton
    navigationItem.rightBarButtonItems = [self.mainView.reportButton, self.mainView.exitButton]
  }

  override func bindViewModel() {
    self.setupDataSource()

    let onAppear = self.rx.viewWillAppear
      .asDriver()
      .map { _ in }
    let refresh = self.mainView.refreshControl.rx.controlEvent(.valueChanged)
      .asDriver()

    let input = ChatRoomViewModel.Input(
      onAppear: onAppear,
      refresh: refresh,
      backButtonTapped: self.mainView.backButton.rx.tap.asDriver(),
      reportButtonTapped: self.mainView.reportButton.rx.tap.asDriver(),
      exitButtonTapped: self.mainView.exitButton.rx.tap.asDriver()
    )
    let output = self.viewModel.transform(input: input)

    self.view.rx.tapGesture()
      .when(.recognized)
      .asDriverOnErrorJustEmpty()
      .drive(with: self) { owner, _ in
        owner.view.endEditing(true)
      }.disposed(by: disposeBag)

    output.items
      .drive(with: self, onNext: { owner, items in
        owner.mainView.collectionView.refreshControl?.endRefreshing()
        owner.mainView.collectionView.backgroundView?.isHidden = !items.isEmpty
        owner.refreshDataSource(items)
      })
      .disposed(by: disposeBag)
    output.room
      .drive(with: self, onNext: { owner, room in
        owner.navigationItem.title = room.partnerName
        owner.mainView.topicBind(String(room.partnerName.prefix(5)), room.currentMessage)
      })
      .disposed(by: disposeBag)
  }
}

extension ChatRoomViewController {
  typealias Model = ChatRoom
  typealias DataSource = UICollectionViewDiffableDataSource<MainSection, Model>
  typealias Snapshot = NSDiffableDataSourceSnapshot<MainSection, Model>

  enum MainSection: Hashable {
    case main
  }

  func setupDataSource() {
    let bubbleRegistration = UICollectionView.CellRegistration<ChatBubbleCell, Model> { cell, indexPath, item in
      cell.bind(item, state: .all)
    }
    let myBubbleRegistration = UICollectionView.CellRegistration<MyChatBubbleCell, Model> { cell, indexPath, item in
      cell.bind(item, state: .contentWithDate)
    }
    self.dataSource = DataSource(collectionView: self.mainView.collectionView, cellProvider: { collectionView, indexPath, item in
      if item.isAvailableChat {
        collectionView.dequeueConfiguredReusableCell(using: bubbleRegistration, for: indexPath, item: item)
      } else {
        collectionView.dequeueConfiguredReusableCell(using: myBubbleRegistration, for: indexPath, item: item)
      }
    })
    refreshDataSource([])
  }

  func refreshDataSource(_ items: [Model]) {
    var snapShot = Snapshot()
    snapShot.appendSections([.main])
    snapShot.appendItems(items)
    self.dataSource.apply(snapShot, animatingDifferences: false)
  }
}

//#if canImport(SwiftUI) && DEBUG
//import SwiftUI
//
//struct ViewController_Preview: PreviewProvider {
//    static var previews: some View {
//      let useCase = ChatUseCase(repository: ChatRepository(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil))
//
//      let viewModel = ChatHomeViewModel(chatUseCase: <#T##ChatUseCaseInterface#>)
//      let viewController = ChatHomeViewController(viewModel: viewModel)
//      return viewController.showPreview()
//    }
//}
//#endif

