//
//  PhotoInputViewController.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/18.
//

import UIKit
import PhotosUI

import DSKit

import RxSwift
import RxCocoa

final class PhotoInputViewController: TFBaseViewController {
  var dataSource: DataSource!
  private(set) var mainView = PhotoInputView()
  private let viewModel: PhotoInputViewModel

  init(viewModel: PhotoInputViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    self.view = mainView
  }

  override func makeUI() {
    configureDataSource()
    mainView.photoCollectionView.backgroundColor = .clear
  }

  override func bindViewModel() {

    let requiredCell = mainView.photoCollectionView.rx.itemSelected
      .asDriver()
      .filter { $0.item < 2 }
    let optionalCell = mainView.photoCollectionView.rx.itemSelected
      .filter { $0.item == 2 }

    let alertTrigger = optionalCell
      .flatMapLatest { indexPath in
        return Observable<PhotoAlertAction>.create { [weak self] observer in
          let alert = UIAlertController(title: "사진 수정하기",
                                        message: "",
                                        preferredStyle: .actionSheet
          )
          let editAction = UIAlertAction(title: "수정", style: .default, handler: { _ -> () in observer.onNext(.edit(indexPath)) })
          let deleteAction = UIAlertAction(title: "제거", style: .destructive, handler: { _ -> () in observer.onNext(.delete(indexPath)) })
          let noAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ -> () in
            observer.onCompleted()
          })
          alert.addAction(editAction)
          alert.addAction(deleteAction)
          alert.addAction(noAction)

          self?.present(alert, animated: true, completion: nil)
          return Disposables.create {
            self?.dismiss()
          }
        }
      }.asDriverOnErrorJustEmpty()


    let nextBtnTap = mainView.nextBtn.rx.tap.asDriver()

    let input = PhotoInputViewModel.Input(
      cellTap: requiredCell, alertTap: alertTrigger,
      nextBtnTap: nextBtnTap
    )

    let output = viewModel.transform(input: input)

    output.images
      .drive(with: self) { owner, items in
        owner.updateSnapshot(items: items)
      }.disposed(by: disposeBag)
    output.nextBtn
      .drive(with: self) { owner, status in
        owner.mainView.nextBtn.updateColors(status: status)
      }
      .disposed(by: disposeBag)
  }
}

extension PhotoInputViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true)

    // Listenr에게 result 전달

    // VM -> Coordinator
    // Coordinattor -> PHPicker
    // PHPicker -> Coordinator(Listener에게 전달) == VM
    // VM -> VC

  }
}



#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct PhotoInputViewController_Preview: PreviewProvider {
  static var previews: some View {
    let vm = PhotoInputViewModel()
    let vc = PhotoInputViewController(viewModel: vm)
    return vc.showPreview()
  }
}
#endif
