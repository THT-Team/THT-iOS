//
//  ViewModelBindingProtocol.swift
//  MyPageInterface
//
//  Created by Kanghos on 7/11/24.
//

import UIKit

import DSKit
import Core

protocol ViewModelBinding: AnyObject {
  associatedtype ViewModel: AnyObject, ViewModelType
  var viewModel: ViewModel? { get set }
  var disposeBag: DisposeBag { get set }

  func bind(_ viewModel: ViewModel)
}

extension ViewModelBinding {
  public var viewModel: ViewModel? {
    get { self.viewModel }
    set {
      if let viewModel = newValue {
        self.disposeBag = DisposeBag()
        self.bind(viewModel)
      }
    }
  }
}

open class TFVC<ViewModel: AnyObject & ViewModelType, MainView: UIView>: TFBaseViewController, ViewModelBinding {
  open var mainView: MainView = MainView()

  open override func loadView() {
    self.view = mainView
  }

  open func bind(_ viewModel: ViewModel) {
    fatalError("bind(viewModel:) has not been implemented")
  }

  public init(viewModel: ViewModel) {
    defer { self.viewModel = viewModel }
    super.init()
  }

  public var viewModel: ViewModel? {
    didSet {
      if let viewModel = viewModel {
        self.disposeBag = DisposeBag()
        self.bind(viewModel)
      }
    }
  }
}
