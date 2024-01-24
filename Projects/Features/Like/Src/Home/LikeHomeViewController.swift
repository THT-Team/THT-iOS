//
//  LikeViewController.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit

import Core
import DSKit
import LikeInterface

enum LikeCellButtonAction {
  case reject(IndexPath)
  case chat(IndexPath)
  case profile(IndexPath)
}

public final class LikeHomeViewController: TFBaseViewController {
  private lazy var mainView = HeartListView()
  private var dataSource: DataSource!

  private let viewModel: LikeHomeViewModel

  init(viewModel: LikeHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func loadView() {
    self.view = mainView
  }

  public override func navigationSetting() {
    super.navigationSetting()

    navigationItem.title = "나를 좋아요한 무디"
    let noti = UIBarButtonItem(image: DSKitAsset.Image.Icons.bell.image, style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = noti
  }
  
  public override func bindViewModel() {
      self.mainView.collectionView.delegate = self

      let cellButtonSubject = PublishSubject<LikeCellButtonAction>()
      self.setupDataSource(observer: cellButtonSubject.asObserver())
    

      let initialTrigger = self.rx.viewWillAppear
        .map { _ in }
        .asDriverOnErrorJustEmpty()
      let refreshControl = self.mainView.refreshControl.rx.controlEvent(.valueChanged)
        .asDriver()
      let pagingTrigger = self.mainView.collectionView.rx.didEndDragging
        .asDriver()
        .filter { $0 }
        .map { _ in }
        .filter { self.mainView.needPaging }

      let input = LikeHomeViewModel.Input(
        trigger: Driver.merge(initialTrigger, refreshControl),
        cellButtonAction: cellButtonSubject.asDriverOnErrorJustEmpty(),
        pagingTrigger: pagingTrigger
      )

      let output = viewModel.transform(input: input)

      output.chatRoom
        .drive()
        .disposed(by: disposeBag)

      output.heartList
        .drive(onNext: { [weak self] list in
          self?.mainView.emptyView.isHidden = !list.isEmpty

          if self?.mainView.refreshControl.isRefreshing == true {
            self?.mainView.refreshControl.endRefreshing()
          }
          self?.refreshDataSource(list)
        })
        .disposed(by: disposeBag)

      output.pagingList
        .drive(onNext: { [weak self] items in
          self?.pagingDataSource(items)
        }).disposed(by: disposeBag)

      output.profile
        .drive()
        .disposed(by: disposeBag)

      output.reject
        .drive(onNext: { [weak self] item in
          self?.deleteItems(item)
        }).disposed(by: disposeBag)
    }
}

extension LikeHomeViewController {
  typealias DataSource = UICollectionViewDiffableDataSource<HeartListSection, Like>
  typealias Snapshot = NSDiffableDataSourceSnapshot<HeartListSection, Like>

  private func setupDataSource<O: ObserverType>(observer: O) where O.Element == LikeCellButtonAction {
    let likeCellRegistration = UICollectionView.CellRegistration<HeartCollectionViewCell, Like> { cell, indexPath, item in
      cell.bind(observer, index: indexPath)
      cell.bind(viewModel: item)
    }

    let headerRegistration = UICollectionView.SupplementaryRegistration<TFCollectionReusableView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
      supplementaryView.title = "test"
    }

    dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: likeCellRegistration, for: indexPath, item: itemIdentifier)
    })
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
    }
  }
  private func deleteItems(_ item: Like) {
    guard
      let indexPath = self.dataSource.indexPath(for: item),
      let cell = self.mainView.collectionView.cellForItem(at: indexPath) as? HeartCollectionViewCell
    else {
      return
    }
    var snapshot = self.dataSource.snapshot()
    snapshot.deleteItems([item])
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
      cell.frame = CGRect(x: cell.frame.minX - self.mainView.collectionView.frame.width, y: cell.frame.minY, width: cell.frame.width, height: cell.frame.height)
    } completion: { _ in
      self.dataSource.apply(snapshot, animatingDifferences: true)
    }
  }

  private func refreshDataSource(_ items: [Like]) {
    var snapshot = Snapshot()
    var sections: [String: [Like]] = [:]
    items.forEach { item in
      sections[item.topic, default: []].append(item)
    }
    snapshot.appendSections([.main])
    snapshot.appendItems(items)

    self.dataSource.apply(snapshot, animatingDifferences: true)
  }

  private func pagingDataSource(_ items: [Like]) {
    var snapshot = self.dataSource.snapshot()
    snapshot.appendItems(items)
    self.dataSource.apply(snapshot)
  }

  enum HeartListSection: Hashable {
    case main
  }
}

extension LikeHomeViewController: UICollectionViewDelegate {

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    TFLogger.ui.debug("\(#function)")
    if scrollView.contentSize.height - 100 < scrollView.contentOffset.y + scrollView.frame.height {
      TFLogger.ui.debug("need pagination")
    }
  }
}
