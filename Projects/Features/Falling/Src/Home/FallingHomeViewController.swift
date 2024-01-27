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
    let timeOverSubject = PublishSubject<Void>()

    let initialTrigger = Driver<Void>.just(())
    let timerOverTrigger = timeOverSubject.asDriverOnErrorJustEmpty()

    let viewWillAppearTrigger = self.rx.viewWillAppear.map { _ in true }.asDriverOnErrorJustEmpty()
    let viewWillDisAppearTrigger = self.rx.viewWillDisAppear.map { _ in false }.asDriverOnErrorJustEmpty()
    let timerActiveRelay = BehaviorRelay(value: true)
    let cardDoubleTapTrigger = self.homeView.collectionView.rx
      .tapGesture(configuration: { gestureRecognizer, delegate in
        gestureRecognizer.numberOfTapsRequired = 2
      })
      .when(.recognized)
      .withLatestFrom(timerActiveRelay) { !$1 }
      .asDriverOnErrorJustEmpty()

    cardDoubleTapTrigger
      .drive(timerActiveRelay)
      .disposed(by: disposeBag)
    
    Driver.merge(viewWillAppearTrigger, viewWillDisAppearTrigger)
      .drive(timerActiveRelay)
      .disposed(by: disposeBag)
    
    let input = FallingHomeViewModel.Input(
      initialTrigger: initialTrigger,
      timeOverTrigger: timerOverTrigger)
    
    let output = viewModel.transform(input: input)
    
    let profileCellRegistration = UICollectionView.CellRegistration<CellType, ModelType> { cell, indexPath, item in
      let timerActiveTrigger = Driver.combineLatest(
        output.userCardScrollIndex,
        timerActiveRelay.asDriver()
      )
        .filter { indexPath.row == $0.0 }
        .map { $0.1 }
        .debug("cell timer active")

      cell.bind(
        FallinguserCollectionViewCellModel(userDomain: item),
        timerActiveTrigger,
        scrollToNextObserver: timeOverSubject
      )
    }
    dataSource = DataSource(collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
    
    output.userList
      .drive(with: self, onNext: { this, list in
        var snapshot = Snapshot()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list)
        this.dataSource.apply(snapshot)
      }).disposed(by: disposeBag)
    
    output.nextCardIndex
      .drive(with: self, onNext: { this, index in
        this.homeView.collectionView.scrollToItem(
          at: index,
          at: .top,
          animated: true)})
      .disposed(by: self.disposeBag)
  }
}

// MARK: DiffableDataSource

extension FallingHomeViewController {
  typealias CellType = FallingUserCollectionViewCell
  typealias ModelType = FallingUser
  typealias SectionType = FallingProfileSection
  typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ModelType>
  typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ModelType>
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
