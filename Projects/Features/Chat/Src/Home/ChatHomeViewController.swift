//
//  ChatHomeViewController.swift
//  ChatInterface
//
//  Created by Kanghos on 2024/01/11.
//

import UIKit

import DSKit
import ChatInterface
import Domain

final class ChatHomeViewController: TFBaseViewController {
  private lazy var mainView = ChatHomeView()
  private let viewModel: ChatHomeViewModel
  private var dataSource: DataSource!

  init(viewModel: ChatHomeViewModel) {
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

    navigationItem.title = "채팅"
//    navigationItem.rightBarButtonItem = self.mainView.notiButton
  }

  override func bindViewModel() {
    self.setupDataSource()

    let onAppear = self.rx.viewWillAppear
      .asDriver()
      .map { _ in }
    let refresh = self.mainView.refreshControl.rx.controlEvent(.valueChanged)
      .asDriver()

    let input = ChatHomeViewModel.Input(
      onAppear: onAppear,
      refresh: refresh,
      itemSelected: self.mainView.collectionView.rx.itemSelected
        .asDriver()
        .map { $0.item },
      notiTap: self.mainView.notiButton
        .rx.tap
        .asDriver()
    )
    let output = self.viewModel.transform(input: input)

    output.chatRooms
      .drive(with: self, onNext: { owner, chatRooms in
        owner.mainView.collectionView.refreshControl?.endRefreshing()
        owner.mainView.collectionView.backgroundView?.isHidden = !chatRooms.isEmpty
        owner.refreshDataSource(chatRooms)
      })
      .disposed(by: disposeBag)
  }
}

extension ChatHomeViewController {
  typealias Model = ChatRoom
  typealias DataSource = UICollectionViewDiffableDataSource<MainSection, Model>
  typealias Snapshot = NSDiffableDataSourceSnapshot<MainSection, Model>

  enum MainSection: Hashable {
    case main
  }

  func setupDataSource() {
    let cellRegistration = UICollectionView.CellRegistration<ChatRoomCell, Model> { cell, indexPath, item in
      cell.bind(item)
    }
    self.dataSource = DataSource(collectionView: self.mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
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
//    static var previews: some SwiftUI.View {
//      let useCase = ChatUseCase(repository: ChatRepository(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil))
//
//      let viewModel = ChatHomeViewModel(chatUseCase: <#T##ChatUseCaseInterface#>)
//      let viewController = ChatHomeViewController(viewModel: viewModel)
//      return viewController.showPreview()
//    }
//}
//#endif

