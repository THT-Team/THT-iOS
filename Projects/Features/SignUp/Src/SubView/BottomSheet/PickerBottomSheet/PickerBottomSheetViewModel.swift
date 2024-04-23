//
//  PickerBottomSheetViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//
import Foundation

import SignUpInterface

import RxSwift
import RxCocoa

import Core

class PickerBottomSheetViewModel: ViewModelType {
//  private let filterType: Item
  private let initialValue: BottomSheetValueType

  weak var listener: BottomSheetListener?
  weak var delegate: BottomSheetActionDelegate?

  private var disposeBag = DisposeBag()

  init(initialValue: BottomSheetValueType) {
    self.initialValue = initialValue
  }

  public struct Input {
    let selectedItem: Driver<(row: Int, component: Int)>
    let initializeButtonTap: Driver<Void>
  }

  public struct Output {
    let items: Driver<[[Int]]>
  }

  public func transform(input: Input) -> Output {
    let thisYear = Calendar.current.component(.year, from: Date())
    let adultYear = thisYear - 20
    let years = Array(((adultYear - 20)...adultYear).reversed())
    let months = Array(1...12)

    let selectedYear = BehaviorSubject(value: adultYear)
    let selectedMonth = BehaviorSubject(value: 1)
    let selectedDay = BehaviorSubject(value: 1)
//
////    Observable.combineLatest(selectedYear, selectedMonth) { year, month in
////      return Array(1...(Date().daysInMonth(month: month, year: year) + 1))
////    }
    let loadTrigger = Observable.just(Void())
    let calculateDaysTrigger = PublishSubject<Void>()
    let outputItems = Observable.merge(loadTrigger, calculateDaysTrigger)
      .map { _ -> [[Int]] in
        let numberOfDays = Date().daysInMonth(month: try selectedMonth.value(), year: try selectedYear.value())
        return [years, months, Array(1...numberOfDays)]
      }
      .asDriver(onErrorJustReturn: [[1],[2],[3]])
//

    let selectedDate = input.selectedItem
      .debug("selected")
      .withLatestFrom(outputItems) { picker, items in
          let selectedValue = items[picker.component][picker.row]
          if picker.component < 2 {
            if picker.component == 0 {
              selectedYear.onNext(selectedValue)
            } else {
              selectedMonth.onNext(selectedValue)
            }
            calculateDaysTrigger.onNext(())
          } else {
            selectedDay.onNext(selectedValue)
          }
        }.compactMap {
          var dateComponent = DateComponents()
          dateComponent.day = try? selectedDay.value()
          dateComponent.month = try? selectedMonth.value()
          dateComponent.year = try? selectedYear.value()

          return Calendar.current.date(from: dateComponent)
        }
    input.initializeButtonTap
      .withLatestFrom(selectedDate)
      .drive(with: self, onNext: { owner, date in
        owner.listener?.sendData(item: .date(date: date))
        owner.delegate?.sheetInvoke(.onDismiss)
      })
    .disposed(by: disposeBag)

    return Output(
      items: outputItems
    )
  }
}
