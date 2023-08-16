//
//  ImageTestViewModel.swift
//  Falling
//
//  Created by Kanghos on 2023/08/14.
//
import Foundation

import RxSwift
import RxCocoa

final class ImageTestViewModel: ViewModelType {
  private let service: StorageManager
  struct Input {
    let editButtonTap: Driver<Void>
    let imageData: Driver<Data>
  }

  struct Output {
    let downloadURL: Driver<URL>
  }

  private let navigator: ChatNavigator

  init(navigator: ChatNavigator) {
    self.navigator = navigator
    self.service = StorageManager()
  }

  var disposeBag: DisposeBag = DisposeBag()

  func transform(input: Input) -> Output {
    let trigger = input.editButtonTap
    let imageData = trigger.withLatestFrom(input.imageData)
      .flatMapLatest { data in
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyyMMdd hhmmss"
        let time = dateTimeFormatter.string(from: Date())
        return self.service.upload(data: data, key: "\(time)-test")
          .asDriver(onErrorDriveWith: .empty())
      }

    return Output(
      downloadURL: imageData
    )

  }
}
