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
  private var dataSource: UICollectionViewDiffableDataSource<FallingProfileSection, FallingUser>!
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
    
    let notificationButtonItem = UIBarButtonItem(image: DSKitAsset.Image.Icons.bell.image, style: .plain, target: nil, action: nil)
    
    navigationItem.leftBarButtonItem = mindImageItem
    navigationItem.rightBarButtonItem = notificationButtonItem
  }
  
  override func bindViewModel() {
    let initialTrigger = Driver<Void>.just(())
    let timerOverTrigger = self.rx.timeOverTrigger.asDriver()
    
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
    
    let input = FallingHomeViewModel.Input(initialTrigger: initialTrigger,
                                           timeOverTrigger: timerOverTrigger)
    
    let output = viewModel.transform(input: input)
    
    var usersCount = 0
    
    let profileCellRegistration = UICollectionView.CellRegistration<FallingUserCollectionViewCell, FallingUser> { [weak self] cell, indexPath, item in
      let observer = FallingUserCollectionViewCellObserver(
        userCardScrollIndex: output.userCardScrollIndex.asObservable(),
        timerActiveTrigger: timerActiveRelay.asObservable()
      )
      
      cell.bind(model: item)
      cell.bind(observer,
                index: indexPath,
                usersCount: usersCount)
      cell.delegate = self
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: homeView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
    
    output.userList
      .drive(with: self, onNext: { this, list in
        usersCount = list.count
        var snapshot = NSDiffableDataSourceSnapshot<FallingProfileSection, FallingUser>()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list)
        this.dataSource.apply(snapshot)
      }).disposed(by: disposeBag)
    
    output.userCardScrollIndex
      .drive(with: self, onNext: { this, index in
        if usersCount == 0 { return }
        let index = index >= usersCount ? usersCount - 1 : index
        let indexPath = IndexPath(row: index, section: 0)
        this.homeView.collectionView.scrollToItem(at: indexPath,
                                                  at: .top,
                                                  animated: true)
      })
      .disposed(by: self.disposeBag)
  }
}

extension FallingHomeViewController: TimeOverDelegate {
  @objc func scrollToNext() { }
}

extension Reactive where Base: FallingHomeViewController {
  var timeOverTrigger: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.scrollToNext)).map { _ in }
    return ControlEvent(events: source)
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
