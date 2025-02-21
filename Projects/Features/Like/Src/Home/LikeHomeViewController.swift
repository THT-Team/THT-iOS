//
//  LikeViewController.swift
//  LikeInterface
//
//  Created by Kanghos on 2023/12/07.
//

import UIKit

import Core
import DSKit

import Domain

import LikeInterface

public final class LikeHomeViewController: TFBaseViewController {
  private lazy var mainView = HeartListView()
  private var dataSource: DataSource!
  private let cellUpdateTrigger = PublishRelay<Like>()

  private let viewModel: LikeHomeViewModel

  init(viewModel: LikeHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
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

  private let deleteAnimationCompleteRelay = PublishRelay<Like>()

  public override func bindViewModel() {
    self.mainView.collectionView.delegate = self

    let cellButtonSubject = PublishSubject<LikeCellButtonAction>()


    // FIXME: 프로필 닫을때 ViewWillAppear 호출됨
    let initialTrigger = Driver.just(())


    let refreshControl = self.mainView.refreshControl.rx.controlEvent(.valueChanged)
      .asDriver()

    let pagingTrigger = self.mainView.collectionView.rx.didEndDragging
      .asDriver()
      .compactMap { [weak self] endDrag -> Void? in
        if endDrag && self?.mainView.needPaging == true {
          return
        }
        return nil
      }

    let input = LikeHomeViewModel.Input(
      trigger: Driver.merge(initialTrigger, refreshControl),
      viewWillAppear: self.rx.viewWillAppear.asDriver().mapToVoid(),
      cellButtonAction: cellButtonSubject.asDriverOnErrorJustEmpty(),
      pagingTrigger: pagingTrigger,
      cellUpdateTrigger: cellUpdateTrigger.asSignal(),
      deleteAnimationComplete: deleteAnimationCompleteRelay.asDriverOnErrorJustEmpty()
    )

    let output = viewModel.transform(input: input)

    self.setupDataSource(
      observer: cellButtonSubject.asObserver(),
      output: output
    )

    // likeList 와 pagingList가 분리되어 있을 필요가 없어 보임
    // 토픽별로 모아서 보여줘야 하는데 서버에서 Response가 토픽별로 오지 않는다면 스크롤시 상위 토픽에 추가될 가능성이 있음.
    // 토픽별로 모아서 Response 가 오는지 확인 필요 -> 위에 추가되어도 괜찮다고 확인함
    // 레드닷: 1. 액션 존재할때 2. 페이지에서 나갈때
    output.likeList
      .do(onNext: { [weak self] list in
        self?.mainView.emptyView.isHidden = !list.isEmpty
        if self?.mainView.refreshControl.isRefreshing == true {
          self?.mainView.refreshControl.endRefreshing()
        }
      })
      .drive(onNext: { [weak self] list in
        self?.applyItemsToDataSource(list)
      })
      .disposed(by: disposeBag)

    output.reject
      .drive(with: self) { owner, item in
        owner.deleteItems(item)
      }
      .disposed(by: disposeBag)

    output.isBlurHidden
      .debug("isBlurHidden")
      .emit(to: mainView.visualEffectView.rx.isHidden)
      .disposed(by: disposeBag)

    output.toast
      .asObservable()
      .bind(to: TFToast.shared.rx.makeToast)
      .disposed(by: disposeBag)
  }

}

extension LikeHomeViewController {
  typealias DataSource = UICollectionViewDiffableDataSource<String, Like>
  typealias Snapshot = NSDiffableDataSourceSnapshot<String, Like>

  private func setupDataSource<O: ObserverType>(observer: O, output: LikeHomeViewModel.Output) where O.Element == LikeCellButtonAction {

    let likeCellRegistration = UICollectionView.CellRegistration<LikeCVCell, Like> { cell, indexPath, item in
      cell.bind(observer, like: item)
    }

    let noticeHeaderRegistration = UICollectionView.SupplementaryRegistration<LikeNoticeHeader>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, elementKind, indexPath in
      supplementaryView.set(self.dataSource.snapshot().sectionIdentifiers[indexPath.section])
      output.headerLabel
        .drive(onNext: { component in
          supplementaryView.bind(component)
        })
        .disposed(by: supplementaryView.disposeBag)
    }

    let headerRegistration = UICollectionView.SupplementaryRegistration<LikeTitleHeader>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, elementKind, indexPath in
      let sectionTitle = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
      supplementaryView.title = sectionTitle
    }

    dataSource = DataSource(
      collectionView: mainView.collectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in
        return collectionView.dequeueConfiguredReusableCell(
          using: likeCellRegistration,
          for: indexPath,
          item: itemIdentifier
        )
      }
    )

    dataSource.supplementaryViewProvider = { (view, kind, index) in
      index.section == 0
      ? view.dequeueConfiguredReusableSupplementary(using: noticeHeaderRegistration, for: index)
      : view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
    }
  }

  private func deleteItems(_ item: Like) {
    guard
      let indexPath = self.dataSource.indexPath(for: item),
      let cell = self.mainView.collectionView.cellForItem(at: indexPath) as? LikeCVCell
    else {
      return
    }
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
      cell.frame = CGRect(
        origin: .init(x: cell.frame.minX - self.mainView.collectionView.frame.width, y: cell.frame.minY),
        size: cell.frame.size)
    } completion: { [weak self] _ in
      self?.deleteAnimationCompleteRelay.accept(item)
    }
  }

  private func applyItemsToDataSource(_ items: [LikeTopicSection]) {
    var snapshot = Snapshot()

    snapshot.appendSections(items.filter { !$1.isEmpty }.map { $0.key })

    if !items.isEmpty {
      for (topic, list) in items {
        guard !list.isEmpty else { continue }
        snapshot.appendItems(list, toSection: topic)
      }
    }

    dataSource.apply(snapshot, animatingDifferences: true)
  }
}

extension LikeHomeViewController: UICollectionViewDelegateFlowLayout {

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView.contentSize.height - 100 < scrollView.contentOffset.y + scrollView.frame.height {
      TFLogger.ui.debug("need pagination")
    }
  }

  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
    cellUpdateTrigger.accept(item)
  }

  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    section == 0
    ? CGSize(width: collectionView.frame.width, height: 100)
    : CGSize(width: collectionView.frame.width, height: 44)
  }
}
