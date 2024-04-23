//
//  FallingHomeViewController.swift
//  FallingInterface
//
//  Created by SeungMin on 1/11/24.
//

import UIKit

import Core
import DSKit
import FallingInterface

enum FallingCellButtonAction {
  case info(IndexPath)
  case reject(IndexPath)
  case like(IndexPath)
}

enum TimerActiveAction {
  case viewWillDisAppear(Bool)
  case profileDoubleTap(Bool)
  case reportButtonTap(Bool)
  case DimViewTap(Bool)
  
  var state: Bool {
    switch self {
    case .viewWillDisAppear(let flag), .profileDoubleTap(let flag), .reportButtonTap(let flag), .DimViewTap(let flag):
      return flag
    }
  }
}

enum AnimationAction {
  case scroll, delete
}

final class FallingHomeViewController: TFBaseViewController {
  private let viewModel: FallingHomeViewModel
  private var dataSource: DataSource!
  private lazy var homeView = FallingHomeView()
  
  init(viewModel: FallingHomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = homeView
  }
  
  override func navigationSetting() {
    super.navigationSetting()
    
    navigationItem.title = "가치관"
    let mindImageView = UIImageView(image: DSKitAsset.Image.Icons.mind.image)
    let mindImageItem = UIBarButtonItem(customView: mindImageView)
    
    let notificationButtonItem = UIBarButtonItem.noti
    
    navigationItem.leftBarButtonItem = mindImageItem
    navigationItem.rightBarButtonItem = notificationButtonItem
  }
  
  override func bindViewModel() {
    let timeOverSubject = PublishSubject<AnimationAction>()
    
    let initialTrigger = Driver<Void>.just(())
    let timerOverTrigger = timeOverSubject.asDriverOnErrorJustEmpty()
    let fallingCellButtonAction = PublishSubject<FallingCellButtonAction>()
    
    let viewWillDisAppearTrigger = self.rx.viewWillDisAppear.map { _ in
      return TimerActiveAction.viewWillDisAppear(false)
    }.asDriverOnErrorJustEmpty()
    
    let timerActiveRelay = BehaviorRelay<TimerActiveAction>(value: .profileDoubleTap(true))
    
    let profileDoubleTapTriggerObserver = PublishSubject<Void>()
    let profileDoubleTapTrigger = profileDoubleTapTriggerObserver
      .withLatestFrom(timerActiveRelay) {
        return TimerActiveAction.profileDoubleTap(!$1.state)
      }
      .asDriverOnErrorJustEmpty()
    
    let reportButtonTapTriggerObserver = PublishSubject<Void>()
    
    let reportButtonTapTrigger = reportButtonTapTriggerObserver
      .withLatestFrom(timerActiveRelay) { _, _ in 
        return TimerActiveAction.reportButtonTap(false)
      }
      .asDriverOnErrorJustEmpty()
    
    Driver.merge(reportButtonTapTrigger, profileDoubleTapTrigger, viewWillDisAppearTrigger)
      .drive(timerActiveRelay)
      .disposed(by: disposeBag)
    
    let complaintsButtonTapTrigger = PublishRelay<Void>()
    let blockButtonTapTrigger = PublishRelay<Void>()
    
    let input = FallingHomeViewModel.Input(
      initialTrigger: initialTrigger,
      timeOverTrigger: timerOverTrigger,
      cellButtonAction: fallingCellButtonAction.asDriverOnErrorJustEmpty(),
      complaintsButtonTapTrigger: complaintsButtonTapTrigger.asDriverOnErrorJustEmpty(),
      blockButtonTapTrigger: blockButtonTapTrigger.asDriverOnErrorJustEmpty()
    )
    
    let output = viewModel.transform(input: input)
    
    let profileCellRegistration = UICollectionView.CellRegistration<CellType, ModelType> { cell, indexPath, item in
      let timerActiveTrigger = Driver.combineLatest(
        output.nextCardIndexPath,
        timerActiveRelay.asDriver()
      )
        .filter { itemIndexPath, _ in indexPath == itemIndexPath }
        .map { _, timerActiveFlag in timerActiveFlag }
      
      cell.bind(
        FallingUserCollectionViewCellModel(userDomain: item),
        timerActiveTrigger: timerActiveTrigger,
        timeOverSubject: timeOverSubject,
        profileDoubleTapTriggerObserver: profileDoubleTapTriggerObserver,
        fallingCellButtonAction: fallingCellButtonAction,
        reportButtonTapTriggerObserver: reportButtonTapTriggerObserver
      )
    }
    
    let footerRegistration = UICollectionView.SupplementaryRegistration
    <UICollectionReusableView>(elementKind: UICollectionView.elementKindSectionFooter) { _,_,_ in }
    
    dataSource = DataSource(collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
    
    dataSource.supplementaryViewProvider = { (view, kind, index) in
      return self.homeView.collectionView.dequeueConfiguredReusableSupplementary(
        using: footerRegistration,
        for: index
      )
    }
    
    var listCount = 0
    
    output.userList
      .drive(with: self, onNext: { owner, list in
        listCount = list.count
        var snapshot = Snapshot()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list)
        owner.dataSource.apply(snapshot, animatingDifferences: true)
      }).disposed(by: disposeBag)
    
    output.nextCardIndexPath
      .drive(with: self, onNext: { owner, indexPath in
        guard indexPath.row < listCount else { return }
        owner.homeView.collectionView.scrollToItem(
          at: indexPath,
          at: .top,
          animated: true
        )
      })
      .disposed(by: self.disposeBag)
    
    output.infoButtonAction
      .drive(with: self) { owner, indexPath in
        guard let cell = owner.homeView.collectionView.cellForItem(at: indexPath) as? FallingUserCollectionViewCell
        else { return }
        cell.userInfoView.isHidden.toggle()
      }
      .disposed(by: disposeBag)
    
    output.rejectButtonAction
      .drive(with: self) { owner, indexPath in
        guard let cell = owner.homeView.collectionView.cellForItem(at: indexPath) as? FallingUserCollectionViewCell else { return }
        
        cell.rejectLottieView.isHidden = false
        cell.rejectLottieView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          timeOverSubject.onNext(.scroll)
        }
      }
      .disposed(by: disposeBag)
    
    reportButtonTapTriggerObserver.asDriverOnErrorJustEmpty()
      .do { _ in
        self.showAlert(
          leftActionTitle: "신고하기",
          rightActionTitle: "차단하기",
          leftActionCompletion: {
            self.showAlert(action: .complaints)
          },
          rightActionCompletion: {
            self.showAlert(
              action: .block,
              leftActionCompletion: {
                blockButtonTapTrigger.accept(())
              },
              rightActionCompletion: {
                timerActiveRelay.accept(.DimViewTap(true))
              }
            )
          },
          dimActionCompletion: {
            timerActiveRelay.accept(.DimViewTap(true))
          }
        )
      }
      .drive()
      .disposed(by: disposeBag)
    
    Driver.merge(output.complaintsAction, output.blockAction)
      .do { indexPath in
//        timerActiveRelay.accept(.DimViewTap(true))
        self.deleteItems(indexPath)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          timeOverSubject.onNext(.delete)
          timerActiveRelay.accept(.DimViewTap(true))
        }
        
//        timerActiveRelay.accept(.DimViewTap(true))
        
        
      }
      .drive()
      .disposed(by: disposeBag)
  }
}

// MARK: DiffableDataSource

extension FallingHomeViewController {
  typealias CellType = FallingUserCollectionViewCell
  typealias ModelType = FallingUser
  typealias SectionType = FallingProfileSection
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>
  
  private func deleteItems(_ indexPath: IndexPath) {
    guard
      let item = self.dataSource.itemIdentifier(for: indexPath),
      let cell = self.homeView.collectionView.cellForItem(at: indexPath) as? FallingUserCollectionViewCell else { return }
    var snapshot = self.dataSource.snapshot()
    snapshot.deleteItems([item])
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
      cell.transform = cell.transform.rotated(by: -.pi / 6).concatenating(cell.transform.translatedBy(x: cell.frame.minX - self.homeView.collectionView.frame.width, y: 37.62))
    } completion: { [weak self] _ in
      guard let self = self else { return }

//      self.dataSource.apply(snapshot)
    }
  }
}

//#if DEBUG
//import SwiftUI
//import RxGesture
//
//struct MainViewControllerPreView: PreviewProvider {
//  static var previews: some View {
//    let service = FallingAPI(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil)
//    let navigator = MainNavigator(controller: UINavigationController(), fallingService: service)
//
//    let viewModel = MainViewModel(navigator: navigator, service: service)
//
//    return FallingHomeViewController(viewModel: viewModel)
//      .toPreView()
//  }
//}
//#endif
