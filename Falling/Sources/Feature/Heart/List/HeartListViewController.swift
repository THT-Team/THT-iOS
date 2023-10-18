//
//  HeartListViewController.swift
//  Falling
//
//  Created by Kanghos on 2023/07/11.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

enum LikeCellButtonAction {
  case reject(IndexPath)
  case chat(IndexPath)
  case profile(IndexPath)
}

final class HeartListViewController: TFBaseViewController {
  private let viewModel: HeartListViewModel


  private lazy var blurEffect = UIBlurEffect(style: .regular)
  private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
    layout.minimumLineSpacing = 8
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(cellType: HeartCollectionViewCell.self)
    collectionView.register(viewType: TFCollectionReusableView.self, kind: UICollectionView.elementKindSectionHeader)
    collectionView.backgroundColor = FallingAsset.Color.neutral700.color
    collectionView.delegate = self
    collectionView.refreshControl = self.refreshControl
    return collectionView
  }()

  private lazy var refreshControl: UIRefreshControl = {
    let refreshControl = UIRefreshControl()
    return refreshControl
  }()

  init(viewModel: HeartListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func navigationSetting() {
    super.navigationSetting()

    navigationItem.title = "나를 좋아요한 무디"
    let noti = UIBarButtonItem(image: FallingAsset.Image.bell.image, style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem = noti
  }

  private let emptyView = TFEmptyView(
    image: FallingAsset.Bx.noLike.image,
    title: "아직 만난 무디가 없네요.",
    subTitle: "먼저 마음이 잘 맞는 무디들을 찾아볼까요?",
    buttonTitle: "무디들 만나러 가기"
  )

  override func makeUI() {
    self.view.addSubview(visualEffectView)
    self.view.addSubview(collectionView)
    self.view.addSubview(emptyView)

    visualEffectView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    collectionView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
    emptyView.snp.makeConstraints {
      $0.edges.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    visualEffectView.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    visualEffectView.isHidden = false
  }

  override func bindViewModel() {
    let likeCellButtonSubject = PublishSubject<LikeCellButtonAction>()

    let dataSource = RxCollectionViewSectionedAnimatedDataSource<LikeSection>(animationConfiguration: AnimationConfiguration(reloadAnimation: .fade, deleteAnimation: .fade)) {  dataSource, collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HeartCollectionViewCell.self)
      cell.bind(likeCellButtonSubject.asObserver(), index: indexPath)
      cell.bind(viewModel: item)
      return cell
    }  configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
      let header = collectionView.dequeueReusableView(for: indexPath, ofKind: kind, viewType: TFCollectionReusableView.self)
      let title = dataSource[indexPath.section].header
      header.title = title
      return header
    } canMoveItemAtIndexPath: { dataSource, indexPath in
      let item = dataSource[indexPath]
      return true
    }

    collectionView.rx.didEndDisplayingCell.map { cell, indexPath in
      guard let heartCell = cell as? HeartCollectionViewCell else {
        TFLogger.view.error("didEndDisplay: cell 변환 error")
        return
      }
      heartCell.disposeBag = DisposeBag()
    }.subscribe(onNext: {
      TFLogger.view.debug("disebose bag refresh")
    }).disposed(by: disposeBag)
    let initialTrigger = self.rx.viewWillAppear.map { _ in }.asDriverOnErrorJustEmpty()
    let refreshControl = self.refreshControl.rx.controlEvent(.valueChanged).asDriver()

    let input = HeartListViewModel.Input(
      trigger: Driver.merge(initialTrigger, refreshControl),
      cellButtonAction: likeCellButtonSubject.asDriverOnErrorJustEmpty()
    )
    emptyView.isHidden = true

    let output = viewModel.transform(input: input)

    output.chatRoom
      .drive()
      .disposed(by: disposeBag)

    output.heartList
      .do(onNext: { [weak self] list in
        self?.emptyView.isHidden = !list.isEmpty
        self?.refreshControl.endRefreshing()
      })
      .drive(collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
        output.profile
        .drive()
        .disposed(by: disposeBag)
  }

  deinit {
    print("[Deinit]: \(self)")
  }
}
extension HeartListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let bound = UIScreen.main.bounds
    let width = bound.width - 14 * 2
    let height = width * (108 / 358)
    return CGSize(width: width, height: height)
  }
}
