//
//  PickerBottomSheetViewModel.swift
//  SignUp
//
//  Created by Kanghos on 2024/04/16.
//
import Foundation

import RxSwift
import RxCocoa

import Core

public class PickerBottomSheetViewModel: ViewModelType {
//  private let filterType: Item
  private let initialValue: BottomSheetValueType

  public weak var listener: BottomSheetListener?
  public weak var delegate: BottomSheetActionDelegate?

  private var disposeBag = DisposeBag()

  public init(initialValue: BottomSheetValueType) {
    self.initialValue = initialValue
  }

  public struct Input {
    let selectedItem: Driver<(row: Int, component: Int)>
    let initializeButtonTap: Driver<Void>
  }

  public struct Output {
    let items: Driver<[[Int]]>
    let initialDate: Driver<(Int, Int)>
  }

  public func transform(input: Input) -> Output {
    let thisYear = Calendar.current.component(.year, from: Date())
    let adultYear = thisYear - 21
    let years = Array(((adultYear - 20)...adultYear).reversed())
    let months = Array(1...12)

    let selectedYear = BehaviorSubject(value: adultYear)
    let selectedMonth = BehaviorSubject(value: 1)
    let selectedDay = BehaviorSubject(value: 1)

    let loadTrigger = Observable.just(Void())
    let calculateDaysTrigger = PublishSubject<Void>() // 월마다 일 수가 달라서 만듦.
    let outputItems = Observable.merge(loadTrigger, calculateDaysTrigger)
      .map { _ -> [[Int]] in
        let numberOfDays = Date().daysInMonth(month: try selectedMonth.value(), year: try selectedYear.value())
        return [years, months, Array(1...numberOfDays)]
      }
      .asDriver(onErrorJustReturn: [[1],[2],[3]])

    let initialDate = outputItems
      .map { _ in }
      .asObservable()
      .take(1)
      .withUnretained(self)
      .flatMap { owner, _ in
        if case let .date(date) = owner.initialValue {
          // 값 동기화 위해서 사용함
          // 하지 않으면, 연/월/일 컴포넌트 중 하나만 움직였을 시, VC값과 VM값 차이가 발생함.
          let compoents = Calendar.current.dateComponents([.year, .month, .day], from: date)
          selectedYear.onNext(compoents.year ?? adultYear)
          selectedMonth.onNext(compoents.month ?? 1)
          selectedDay.onNext(compoents.day ?? 1)
          return Observable.just(date)
        }
        return Observable.empty()
      }
      .asDriverOnErrorJustEmpty()

    let initialComponents = initialDate
      .map { date in
        // TODO: (Int, Int) tuple 형태로 만들고 reduce하여 array 형태로 전달
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let thisYear = Calendar.current.component(.year, from: Date())
        let adultYear = thisYear - 21 // max값
        
        let yearIdx = adultYear - calendar.component(.year, from: date)
        let monthIdx = calendar.component(.month, from: date) - 1
        let dayIdx = calendar.component(.day, from: date) - 1

        return [(yearIdx, 0), (monthIdx, 1), (dayIdx, 2)]
      }
      .flatMap { components in
        return Driver.from(components)
      }
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
    let outputDate = Driver.merge(initialDate, selectedDate)

    input.initializeButtonTap
      .withLatestFrom(outputDate)
      .drive(with: self, onNext: { owner, date in
        owner.listener?.sendData(item: .date(date: date))
        owner.delegate?.sheetInvoke(.onDismiss)
      })
    .disposed(by: disposeBag)

    return Output(
      items: outputItems,
      initialDate: initialComponents
    )
  }
}
