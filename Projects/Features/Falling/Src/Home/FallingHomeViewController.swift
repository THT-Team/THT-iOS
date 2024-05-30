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
  case reject(IndexPath)
  case like(IndexPath)
}

enum AnimationAction {
  case scroll, delete
}

final class FallingHomeViewController: TFBaseViewController {
  private let viewModel: FallingHomeViewModel
  private var dataSource: DataSource!
  private lazy var homeView = FallingHomeView()
  
  private lazy var alertContentView = TFAlertContentView()
  
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
      return false
    }.asDriverOnErrorJustEmpty()
    
    let timerActiveRelay = BehaviorRelay<Bool>(value: true)
    
    let profileDoubleTapTriggerObserver = PublishSubject<Void>()
    let profileDoubleTapTrigger = profileDoubleTapTriggerObserver
      .withLatestFrom(timerActiveRelay) {
        return !$1
      }
      .asDriverOnErrorJustEmpty()
    
    let reportButtonTapTriggerObserver = PublishSubject<Void>()
    
    let reportButtonTapTrigger = reportButtonTapTriggerObserver
      .withLatestFrom(timerActiveRelay) { _, _ in 
        return false
      }
      .asDriverOnErrorJustEmpty()
    
    Driver.merge(reportButtonTapTrigger, profileDoubleTapTrigger, viewWillDisAppearTrigger)
      .drive(timerActiveRelay)
      .disposed(by: disposeBag)
    
    let complaintsButtonTapTrigger = PublishRelay<Void>()
    let blockButtonTapTrigger = PublishRelay<Void>()
    
    let deleteCellTrigger = Driver.merge(complaintsButtonTapTrigger.asDriverOnErrorJustEmpty(), blockButtonTapTrigger.asDriverOnErrorJustEmpty())
    
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
        reportButtonTapTriggerObserver: reportButtonTapTriggerObserver,
        deleteCellTrigger: deleteCellTrigger
      )
    }
    
    let footerRegistration = UICollectionView.SupplementaryRegistration
    <DummyFooterView>(elementKind: UICollectionView.elementKindSectionFooter) { _,_,_ in }
    
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
    
    output.likeButtonAction
      .drive(with: self) { owner, _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
          timeOverSubject.onNext(.scroll)
        }
      }
      .disposed(by: disposeBag)
    
    output.rejectButtonAction
      .drive(with: self) { owner, _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          timeOverSubject.onNext(.scroll)
        }
      }
      .disposed(by: disposeBag)
    
    Driver.merge(
      alertContentView.unpleasantPhotoButton.rx.tap.asDriver(),
      alertContentView.fakeProfileButton.rx.tap.asDriver(),
      alertContentView.photoTheftButton.rx.tap.asDriver(),
      alertContentView.profanityButton.rx.tap.asDriver(),
      alertContentView.sharingIllegalFootageButton.rx.tap.asDriver())
    .do { _ in
      complaintsButtonTapTrigger.accept(())
      
      self.homeView.makeToast("신고하기가 완료되었습니다. 해당 사용자와\n서로 차단되며, 신고 사유는 검토 후 처리됩니다.", duration: 3.0, position: .bottom)
      
      UIWindow.keyWindow?.rootViewController?.dismiss(animated: false)
    }
    .drive()
    .disposed(by: disposeBag)
    
    reportButtonTapTriggerObserver.asDriverOnErrorJustEmpty()
      .do { _ in
        self.showAlert(
          topActionTitle: "신고하기",
          bottomActionTitle: "차단하기",
          dimColor: DSKitAsset.Color.clear.color,
          topActionCompletion: {
            self.showAlert(
              contentView: self.alertContentView,
              topActionTitle: nil,
              dimColor: DSKitAsset.Color.clear.color,
              bottomActionCompletion: { timerActiveRelay.accept(true) },
              dimActionCompletion: { timerActiveRelay.accept(true) }
            )
          },
          bottomActionCompletion: {
            self.showAlert(
              action: .block,
              dimColor: DSKitAsset.Color.clear.color,
              topActionCompletion: {
                blockButtonTapTrigger.accept(())
                
                self.homeView.makeToast("차단하기가 완료되었습니다. 해당 사용자와\n서로 차단되며 설정에서 확인 가능합니다.", duration: 3.0, position: .bottom)
              },
              bottomActionCompletion: { timerActiveRelay.accept(true) },
              dimActionCompletion: { timerActiveRelay.accept(true) }
            )
          },
          dimActionCompletion: { timerActiveRelay.accept(true) }
        )
      }
      .drive()
      .disposed(by: disposeBag)
    
    Driver.merge(output.complaintsAction, output.blockAction)
      .do { indexPath in
        guard let _ = self.homeView.collectionView.cellForItem(at: indexPath) as? FallingUserCollectionViewCell else { return }
        
        self.deleteItems(indexPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          timeOverSubject.onNext(.delete)
          timerActiveRelay.accept(true)
        }
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
