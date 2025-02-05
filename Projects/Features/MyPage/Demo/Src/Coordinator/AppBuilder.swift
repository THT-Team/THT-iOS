////
////  AppRootBuilder.swift
////  Feature
////
////  Created by Kanghos on 2023/12/06.
////
//
//import UIKit
//
//import DSKit
//import MyPage
//import MyPageInterface
//import Auth
//import AuthInterface
//import Domain
//
//public protocol AppRootBuildable {
//  func build() -> LaunchCoordinating
//}
//
//final class AppRootComponent: MyPageDependency {
//  var viewControllable: Core.ViewControllable
//  
//  lazy var mySettingBuildable: MyPageInterface.MySettingBuildable = {
//    MySettingBuilder(dependency: self)
//  }()
//
//  lazy var myPageAlertBuildable: MyPageInterface.MyPageAlertBuildable = {
//    MyPageAlertBuilder()
//  }()
//
//  lazy var inquiryBuildable: InquiryBuildable = {
//    InquiryBuilder()
//  }()
//
//  lazy var authViewFactory: AuthInterface.AuthViewFactoryType = {
//    AuthViewFactory()
//  }()
//
//  init(viewControllable: ViewControllable) {
//    self.viewControllable = viewControllable
//  }
//}
//
//public final class AppRootBuilder: AppRootBuildable {
//
//  public func build() -> LaunchCoordinating {
//
//    let viewController = NavigationViewControllable(rootViewControllable: TFLaunchViewController())
//
//    let component = AppRootComponent(viewControllable: viewController)
//    let myPageBuilder = MyPageBuilder(dependency: component)
//
//    let coordinator = AppCoordinator(
//      viewControllable: viewController,
//      myPageBuildable: myPageBuilder
//    )
//    return coordinator
//  }
//}
//
