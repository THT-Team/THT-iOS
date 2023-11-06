//
//  MainViewController.swift
//  Falling
//
//  Created by SeungMin on 2023/08/15.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

final class MainViewController: TFBaseViewController {
  
  private let viewModel: MainViewModel
  private var dataSource: UICollectionViewDiffableDataSource<MainProfileSection, UserDomain>!
  private lazy var mainView = MainView()
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    setupDelegate()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = mainView
  }
  
  override func navigationSetting() {
    super.navigationSetting()
    
    navigationItem.title = "가치관"
    let mindImageView = UIImageView(image: FallingAsset.Image.mind.image)
    let mindImageItem = UIBarButtonItem(customView: mindImageView)
    
    let notificationButtonItem = UIBarButtonItem(image: FallingAsset.Image.bell.image, style: .plain, target: nil, action: nil)
    
    navigationItem.leftBarButtonItem = mindImageItem
    navigationItem.rightBarButtonItem = notificationButtonItem
  }
  
  override func bindViewModel() {
    let initialTrigger = Driver<Void>.just(())
    let timerOverTrigger = self.rx.timeOverTrigger.map { _ in
    }.asDriverOnErrorJustEmpty()
    
    let viewWillAppearTrigger = self.rx.viewWillAppear.map { _ in true }
    
    let viewWillDisAppearTrigger = self.rx.viewWillDisAppear.map { _ in false }
    
    let doubleTapGesture = UITapGestureRecognizer()
    doubleTapGesture.numberOfTapsRequired = 2
    
    let cardDoubleTapTrigger = self.mainView.collectionView.rx
      .gesture(doubleTapGesture)
      .when(.recognized)
      .map { _ in }
    
    let timerActiveRelay = BehaviorRelay(value: true)
    
    cardDoubleTapTrigger
      .withLatestFrom(timerActiveRelay)
      .do { value in
        timerActiveRelay.accept(!value)
      }
      .asDriver(onErrorJustReturn: false)
      .drive()
      .disposed(by: disposeBag)
    
    Observable.merge(viewWillAppearTrigger, viewWillDisAppearTrigger)
      .do { value in
        timerActiveRelay.accept(value)
      }
      .asDriver(onErrorJustReturn: false)
      .drive()
      .disposed(by: disposeBag)
    
    let input = MainViewModel.Input(initialTrigger: initialTrigger,
                                    timeOverTrigger: timerOverTrigger)
    
    let output = viewModel.transform(input: input)
    
    var usersCount = 0
    
    let profileCellRegistration = UICollectionView.CellRegistration<MainCollectionViewCell, UserDomain> { [weak self] cell, indexPath, item in
      
      let observer = MainCollectionViewCellObserver(userCardScrollIndex: output.userCardScrollIndex.asObservable(),
                                                    timerActiveTrigger: timerActiveRelay.asObservable())
      
      cell.bind(model: item)
      cell.bind(observer,
                index: indexPath,
                usersCount: usersCount)
      cell.delegate = self
    }
    
    dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
      return collectionView.dequeueConfiguredReusableCell(using: profileCellRegistration, for: indexPath, item: itemIdentifier)
    })
    
    output.userList
      .drive(onNext: { [weak self] list in
        usersCount = list.count
        var snapshot = NSDiffableDataSourceSnapshot<MainProfileSection, UserDomain>()
        snapshot.appendSections([.profile])
        snapshot.appendItems(list)
        self?.dataSource.apply(snapshot, animatingDifferences: true)
      }).disposed(by: disposeBag)
    
    output.userCardScrollIndex
      .do(onNext: { index in
        let index = index >= usersCount ? usersCount - 1 : index
        let indexPath = IndexPath(row: index, section: 0)
        self.mainView.collectionView.scrollToItem(at: indexPath,
                                                  at: .top,
                                                  animated: true)
      }).drive()
      .disposed(by: self.disposeBag)
  }
  
  private func setupDelegate() {
    mainView.collectionView.delegate = self
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width - 32,
                  height: (view.frame.width - 32) * 1.64)
  }
}

extension MainViewController: TimeOverDelegate {
  @objc func scrollToNext() { }
}

extension Reactive where Base: MainViewController {
  var timeOverTrigger: ControlEvent<Void> {
    let source = methodInvoked(#selector(Base.scrollToNext)).map { _ in }
    return ControlEvent(events: source)
  }
}

#if DEBUG
import SwiftUI
import RxGesture

struct MainViewControllerPreView: PreviewProvider {
  static var previews: some View {
    let service = FallingAPI(isStub: true, sampleStatusCode: 200, customEndpointClosure: nil)
    let navigator = MainNavigator(controller: UINavigationController(), fallingService: service)
    
    let viewModel = MainViewModel(navigator: navigator, service: service)
    
    return MainViewController(viewModel: viewModel)
      .toPreView()
  }
}
#endif
